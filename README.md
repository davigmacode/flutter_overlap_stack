[![Pub Version](https://img.shields.io/pub/v/overlap_stack)](https://pub.dev/packages/overlap_stack) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_overlap_stack) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

OverlapStack intelligently stacks your widgets, allowing them to partially overlap for a compact and visually interesting layout. This space-saving solution is perfect for user lists, chat previews, or any situation where you want to showcase multiple elements without cluttering the screen.

[![Preview](https://github.com/davigmacode/flutter_overlap_stack/raw/main/media/preview.gif)](https://davigmacode.github.io/flutter_overlap_stack)

[Demo](https://davigmacode.github.io/flutter_overlap_stack)

## Usage

To read more about classes and other references used by `overlap_stack`, see the [API Reference](https://pub.dev/documentation/overlap_stack/latest/).

```dart
OverlapStack(
  minSpacing: 0.5,
  maxSpacing: 0.5,
  itemSize: const Size(64, 32),
  children: List<Widget>.generate(9, (i) {
    return Container(
      width: 64,
      height: 32,
      alignment: Alignment.center,
      color: Colors.amber[(i + 1) * 100]!,
      child: const FlutterLogo(),
    );
  }),
)

Container(
  color: Colors.black12,
  height: 40,
  child: OverlapStack.builder(
    minSpacing: 0.5,
    maxSpacing: 0.8,
    // align: OverlapStackAlign.end,
    leadIndex: 3,
    // infoIndex: 3,
    // itemSize: const Size.square(40),
    itemLimit: 12,
    itemCount: 25,
    itemBuilder: (context, i) {
      return CircleAvatar(
        foregroundImage: NetworkImage(
          'https://i.pravatar.cc/50?u=$i',
        ),
      );
    },
    infoBuilder: (context, remaining) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: Text('+$remaining'),
      );
    },
  ),
)
```

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.