import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:plataform_channel_game/constants/colors.dart';
import 'package:plataform_channel_game/constants/styles.dart';
import 'package:plataform_channel_game/models/creator.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  Creator? creator;
  bool minhaVez = false;

  // se == 0 branco, se == 1 eu, se == 2 oponente jogou
  List<List<int>> cells = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(700, 1400));

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(550),
                    height: ScreenUtil().setHeight(550),
                    color: colorLightBlue1,
                  ),
                  Container(
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setHeight(550),
                    color: colorMidiumBlue2,
                  ),
                ],
              ),
              Container(
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setHeight(850),
                color: colorDarkBlue3,
              )
            ],
          ),
          Container(
            height: ScreenUtil().setHeight(1400),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                creator == null
                    ? Row(mainAxisSize: MainAxisSize.min, children: [
                        buildButton("Criar", true),
                        SizedBox(width: 10),
                        buildButton("Entrar", false),
                      ])
                    : InkWell(
                        child: Text(
                            minhaVez == true
                                ? "Faça sua jogada"
                                : "Aguarde sua vez",
                            style: textStyle36),
                        onLongPress: () {
                          _sendMessage();
                        },
                      ),
                GridView.count(
                  crossAxisCount: 3,
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    getCell(0, 0),
                    getCell(0, 1),
                    getCell(0, 2),
                    getCell(1, 0),
                    getCell(1, 1),
                    getCell(1, 2),
                    getCell(2, 0),
                    getCell(2, 1),
                    getCell(2, 2)
                  ],
                )
              ],
            )),
          )
        ],
      ),
    ));
  }

  Widget buildButton(String label, bool owner) => Container(
        width: ScreenUtil().setWidth(300),
        child: ElevatedButton(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(label, style: textStyle36)),
          onPressed: () {
            createGame(owner);
          },
        ),
      );

  Future createGame(bool owner) async {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Qual o nome do jogo?"),
            content: TextField(controller: controller),
            actions: [
              ElevatedButton(
                  child: const Text("Jogar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sendAction('subscribe', {'channel': controller.text});
                    //.then((value))
                    setState(() {
                      creator = Creator(owner, controller.text);
                      minhaVez = owner;
                    });
                  })
            ],
          );
        });
  }

  Future _sendAction(String action, Map<String, dynamic> arguments) async {}

  Widget getCell(int x, int y) => InkWell(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.lightBlueAccent,
          child: Center(
            child: Text(
              cells[x][y] == 0
                  ? ""
                  : cells[x][y] == 1
                      ? "X"
                      : "O",
              style: textStyle75,
            ),
          ),
        ),
        onTap: () async {
          if (minhaVez == true && cells[x][y] == 0) {
            _showSendingAction();
            _sendAction('sendAction',
                {'tap': '${creator!.creator ? "p1" : "p2"}|$x|$y'});
            //.then((value){})
            //Navigator.of(context).pop();
            setState(() {
              minhaVez = false;
              cells[x][y] = 1;
            });

            checkWinner();
          }
        },
      );

  void _showSendingAction() {}
  void checkWinner() {}
  void _sendMessage() async {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Digite a mensagem para enviar"),
            content: TextField(controller: controller),
            actions: [
              ElevatedButton(
                  child: const Text("Enviar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sendAction('chat', {
                      'message':
                          '${creator!.creator ? "p1" : "p2"}|${controller.text}'
                    });
                  })
            ],
          );
        });
  }
}
