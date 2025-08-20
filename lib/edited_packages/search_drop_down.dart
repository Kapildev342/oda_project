// Flutter imports:
import 'package:flutter/material.dart';

class SearchableDropdownInOverlay extends StatefulWidget {
  const SearchableDropdownInOverlay({super.key});

  @override
  State<SearchableDropdownInOverlay> createState() => _SearchableDropdownInOverlayState();
}

class _SearchableDropdownInOverlayState extends State<SearchableDropdownInOverlay> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey<FormFieldState> controllerKey = GlobalKey<FormFieldState>();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<String> data = [];
  List<String> searchedData = [];
  TextEditingController controller = TextEditingController();
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    data = List.generate(25, (i) => "Index:$i");
    searchedData = data;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
    if (_focusNode.hasFocus) {
      _showOverlay(context, controllerKey);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay(BuildContext context, GlobalKey key) {
    final overlay = Overlay.of(context);
    _overlayEntry?.remove();
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox!.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeightBelow = screenHeight - position.dy - size.height - keyboardHeight;
    bool showAbove = availableHeightBelow < 200;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0,
              showAbove
                  ? searchedData.isEmpty
                  ? -75.00
                  : searchedData.length > 2
                  ? -200.00
                  : -((searchedData.length * 75).toDouble())
                  : 45),
          child: Material(
            child: GestureDetector(
              child: Container(
                width: size.width,
                constraints: const BoxConstraints(maxHeight: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 0, color: Colors.black26.withOpacity(0.3))]),
                clipBehavior: Clip.hardEdge,
                child: searchedData.isEmpty
                    ? const ListTile(
                  title: Text("No Matches Found"),
                )
                    : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchedData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          isReadOnly = true;
                          controller.text = searchedData[index];
                          _focusNode.unfocus();
                          setState(() {});
                        },
                        title: Text(searchedData[index]),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  searchFunction({required String value}) {
    searchedData = data.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensure taps outside are detected
      onTap: () {
        (data.where((element) => element == controller.text)).toList().isEmpty ? controller.clear() : null;
        searchFunction(value: controller.text);
        _focusNode.unfocus();
        setState(() {});
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          key: controllerKey,
          focusNode: _focusNode,
          controller: controller,
          readOnly: isReadOnly,
          onChanged: (value) {
            searchFunction(value: controller.text);
            _showOverlay(context, controllerKey);
            setState(() {});
          },
          /*   onTapOutside: (value) {
                    (data.where((element) => element == controller.text)).toList().isEmpty ? controller.clear() : null;
                    searchFunction(value: controller.text);
                    _focusNode.unfocus();
                    setState(() {});
                  },*/
          decoration: InputDecoration(
              labelText: "Focus me",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                  onPressed: () {
                    _focusNode.requestFocus();
                    controller.clear();
                    isReadOnly = false;
                    searchFunction(value: "");
                    _showOverlay(context, controllerKey);
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear))),
        ),
      ),
    );
  }
}


class ListValue {
  String id;
  String label;
  String type;

  ListValue({
    required this.id,
    required this.label,
    required this.type,
  });

  factory ListValue.fromJson(Map<String, dynamic> json) => ListValue(
    id: json["id"]??"",
    label: json["label"]??json["description"] ??"",
    type: json["type"]??json["code"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "type": type,
  };
}
