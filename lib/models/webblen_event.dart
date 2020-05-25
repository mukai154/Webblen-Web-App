import 'dart:convert';

import 'package:webblen_web_app/locater.dart';
import 'package:webblen_web_app/routing/route_names.dart';
import 'package:webblen_web_app/services/navigation/navigation_service.dart';

class WebblenEvent {
  String id;
  String authorID;
  String chatID;
  bool hasTickets;
  bool flashEvent;
  bool isDigitalEvent;
  String digitalEventLink;
  String title;
  String desc;
  String imageURL;
  String venueName;
  String streetAddress;
  List nearbyZipcodes;
  String city;
  String province;
  double lat;
  double lon;
  List sharedComs;
  List tags;
  String type;
  String category;
  int clicks;
  String website;
  double checkInRadius;
  int estimatedTurnout;
  int actualTurnout;
  List attendees;
  double eventPayout;
  String recurrence;
  int startDateTimeInMilliseconds;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String timezone;
  String privacy;
  bool reported;

  WebblenEvent({
    this.id,
    this.authorID,
    this.chatID,
    this.hasTickets,
    this.flashEvent,
    this.isDigitalEvent,
    this.digitalEventLink,
    this.title,
    this.desc,
    this.imageURL,
    this.venueName,
    this.nearbyZipcodes,
    this.streetAddress,
    this.city,
    this.province,
    this.lat,
    this.lon,
    this.sharedComs,
    this.tags,
    this.type,
    this.category,
    this.clicks,
    this.website,
    this.checkInRadius,
    this.estimatedTurnout,
    this.actualTurnout,
    this.attendees,
    this.eventPayout,
    this.recurrence,
    this.startDateTimeInMilliseconds,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.timezone,
    this.privacy,
    this.reported,
  });

  WebblenEvent.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          authorID: data['authorID'],
          chatID: data['chatID'],
          hasTickets: data['hasTickets'],
          flashEvent: data['flashEvent'],
          isDigitalEvent: data['isDigitalEvent'],
          digitalEventLink: data['digitalEventLink'],
          title: data['title'],
          desc: data['desc'],
          imageURL: data['imageURL'],
          venueName: data['venueName'],
          nearbyZipcodes: data['nearbyZipcodes'],
          streetAddress: data['streetAddress'],
          city: data['city'],
          province: data['province'],
          lat: data['lat'],
          lon: data['lon'],
          sharedComs: data['sharedComs'],
          tags: data['tags'],
          type: data['type'],
          category: data['category'],
          clicks: data['clicks'],
          website: data['website'],
          checkInRadius: data['checkInRadius'],
          estimatedTurnout: data['estimatedTurnout'],
          actualTurnout: data['actualTurnout'],
          attendees: data['attendees'],
          eventPayout: data['eventPayout'],
          recurrence: data['recurrence'],
          startDateTimeInMilliseconds: data['startDateTimeInMilliseconds'],
          startDate: data['startDate'],
          startTime: data['startTime'],
          endDate: data['endDate'],
          endTime: data['endTime'],
          timezone: data['timezone'],
          privacy: data['privacy'],
          reported: data['reported'],
        );

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'authorID': this.authorID,
        'chatID': this.chatID,
        'hasTickets': this.hasTickets,
        'flashEvent': this.flashEvent,
        'isDigitalEvent': this.isDigitalEvent,
        'digitalEventLink': this.digitalEventLink,
        'title': this.title,
        'desc': this.desc,
        'imageURL': this.imageURL,
        'venueName': this.venueName,
        'nearbyZipcodes': this.nearbyZipcodes,
        'streetAddress': this.streetAddress,
        'city': this.city,
        'province': this.province,
        'lat': this.lat,
        'lon': this.lon,
        'sharedComs': this.sharedComs,
        'tags': this.tags,
        'type': this.type,
        'category': this.category,
        'clicks': this.clicks,
        'website': this.website,
        'checkInRadius': this.checkInRadius,
        'estimatedTurnout': this.estimatedTurnout,
        'actualTurnout': this.actualTurnout,
        'attendees': this.attendees,
        'eventPayout': this.eventPayout,
        'recurrence': this.recurrence,
        'startDateTimeInMilliseconds': this.startDateTimeInMilliseconds,
        'startDate': this.startDate,
        'startTime': this.startTime,
        'endDate': this.endDate,
        'endTime': this.endTime,
        'timezone': this.timezone,
        'privacy': this.privacy,
        'reported': this.reported,
      };

  final NavigationService _navigationService = locator<NavigationService>();
  void navigateToEvent(String eventID) {
    _navigationService.navigateTo(EventsDetailsRoute, queryParams: {'id': eventID});
  }

  void navigateToEventTickets(String eventID) {
    _navigationService.navigateTo(EventTicketsSelectionRoute, queryParams: {'id': eventID});
  }

  void navigateToWalletTickets(String eventID) {
    _navigationService.navigateTo(WalletEventTicketsRoute, queryParams: {'id': eventID});
  }

  void navigateToPurchaseTicketsPage(String eventID, List<Map<String, dynamic>> ticketsToPurchase) {
    _navigationService.navigateTo(EventTicketsPurchaseRoute, queryParams: {'id': eventID, 'ticketsToPurchase': jsonEncode(ticketsToPurchase)});
  }
}