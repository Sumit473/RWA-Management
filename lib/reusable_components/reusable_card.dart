import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {this.cardColor,
        this.imageNo,
        this.cardTitle,
        this.cardDescription,
        this.onTapCard});
  final Color cardColor;
  final int imageNo;
  final String cardTitle;
  final String cardDescription;
  final Function onTapCard;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset('images/$imageNo.png'),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      cardTitle,
                      textScaleFactor: 1.6,
                    ),
                    SizedBox(height: 3),
                    Text(
                      cardDescription,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1.05,
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    const Icon(
                      Icons.navigate_next,
                      size: 25,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
