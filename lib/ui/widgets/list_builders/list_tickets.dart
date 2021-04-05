import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/models/webblen_ticket_distro.dart';
import 'package:webblen_web_app/ui/ui_helpers/ui_helpers.dart';
import 'package:webblen_web_app/ui/widgets/common/custom_text.dart';

class ListTicketsForEditing extends StatelessWidget {
  final WebblenTicketDistro ticketDistro;
  final Function(int) editTicketAtIndex;

  ListTicketsForEditing({@required this.ticketDistro, @required this.editTicketAtIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: appDividerColor(),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Container(
              width: (MediaQuery.of(context).size.width - 16) * 0.40,
              child: CustomText(
                text: 'TICKETS',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: appFontColorAlt(),
              ),
            ),
          ),
          verticalSpaceTiny,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: appDividerColor(),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width - 16) * 0.40,
                  child: CustomText(
                    text: 'Ticket Name',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 16) * 0.20,
                  child: CustomText(
                    text: 'Qty',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 16) * 0.20,
                  child: CustomText(
                    text: 'Price',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: appFontColor(),
                  ),
                ),
                Container(width: 35.0),
              ],
            ),
          ),
          verticalSpaceSmall,
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ticketDistro.tickets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: CustomText(
                        text: ticketDistro.tickets[index]["ticketName"],
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 70,
                      child: CustomText(
                        text: ticketDistro.tickets[index]["ticketQuantity"],
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 70.0,
                      child: CustomText(
                        text: ticketDistro.tickets[index]["ticketPrice"],
                        color: appFontColor(),
                        textAlign: TextAlign.left,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 35.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => editTicketAtIndex(index),
                            child: Icon(FontAwesomeIcons.edit, size: 16.0, color: appFontColor()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
