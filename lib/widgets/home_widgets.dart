import 'package:flutter/material.dart';

import '../sizeconfig.dart';

class HomeContainer extends StatelessWidget {

  final IconData icon;
  final String title;

  const HomeContainer({this.title,this.icon});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeHorizontal * 20,

      child: Row(
        children: <Widget>[
          Spacer(),
          Icon(
            this.icon,color: Theme.of(context).accentColor,
            size: 35,
          ),
          SizedBox(
            width: 20,
          ),
          Text(this.title,style: TextStyle(color: Theme.of(context).accentColor),),
          Spacer(),
        ],
      ),
    );
  }
}
