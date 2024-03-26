import 'package:flutter/material.dart';
import 'package:overlap_stack/overlap_stack.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OverlapStack Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _width = 500.0;

  void _setWidth(double value) {
    setState(() {
      _width = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'OverlapStack',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 40),
              OverlapStack(
                minSpacing: 0.5,
                maxSpacing: 0.5,
                itemSize: const Size(64, 32),
                children: [
                  Container(
                    width: 64,
                    height: 32,
                    alignment: Alignment.center,
                    color: Colors.amber.shade100,
                    child: const FlutterLogo(),
                  ),
                  Container(
                    width: 64,
                    height: 32,
                    alignment: Alignment.center,
                    color: Colors.amber.shade300,
                    child: const FlutterLogo(),
                  ),
                  Container(
                    width: 64,
                    height: 32,
                    alignment: Alignment.center,
                    color: Colors.amber.shade500,
                    child: const FlutterLogo(),
                  ),
                  Container(
                    width: 64,
                    height: 32,
                    alignment: Alignment.center,
                    color: Colors.amber.shade700,
                    child: const FlutterLogo(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.black12,
                width: _width,
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
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Slider(
                    value: _width,
                    min: constraints.minWidth,
                    max: constraints.maxWidth,
                    onChanged: _setWidth,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
