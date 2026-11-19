import '../../features/booking/domain/entities/booking.dart';
import '../../features/events/domain/entities/arena_event.dart';
import '../../features/facilities/domain/entities/facility.dart';
import '../../features/notifications/domain/entities/app_notification.dart';
import '../../features/tournaments/domain/entities/tournament.dart';
import '../../core/utils/formatters.dart';
import '../domain/sport_type.dart';

/// Seed data for Release 1 (local mock mode). Dates are relative to "now"
/// so the demo always looks live.
abstract final class MockCatalog {
  static const facilities = <Facility>[
    Facility(
      id: 'box-turf',
      name: 'The Dino Box',
      headline: 'Cricket + Football Box Turf',
      kind: FacilityKind.boxTurf,
      sports: [SportType.cricket, SportType.football],
      description:
          'A floodlit, fully-netted box turf built for fast 6-a-side football and high-intensity box '
          'cricket. FIFA-grade artificial grass on a shock-absorbing underlay keeps every game quick and safe.',
      pricePerHour: 1200,
      peakPricePerHour: 1600,
      rating: 4.8,
      reviewCount: 326,
      openHour: 6,
      closeHour: 24,
      surface: 'FIFA-grade artificial turf',
      dimensions: '100 ft × 60 ft',
      maxPlayers: 14,
      unitLabel: 'Turf',
      amenities: ['LED floodlights', 'Full netting', 'Changing rooms', 'Drinking water', 'Parking', 'Scoreboard'],
      rules: [
        'Non-marking turf shoes or studs under 6 mm only.',
        'Arrive 10 minutes early — slots start and end on time.',
        'Hard tennis or leather-cover tennis ball only for cricket.',
        'Free cancellation up to 2 hours before your slot.',
      ],
      featured: true,
      badge: 'Most booked',
    ),
    Facility(
      id: 'badminton-court',
      name: 'Shuttle Dome',
      headline: 'Indoor Badminton Court',
      kind: FacilityKind.badmintonCourt,
      sports: [SportType.badminton],
      description:
          'A dedicated indoor court with a BWF-approved synthetic mat, glare-free lighting and high ceilings. '
          'Perfect for singles drills, doubles rallies and coaching sessions.',
      pricePerHour: 400,
      peakPricePerHour: 550,
      rating: 4.7,
      reviewCount: 184,
      openHour: 6,
      closeHour: 23,
      surface: 'BWF-approved synthetic mat',
      dimensions: '44 ft × 20 ft',
      maxPlayers: 4,
      unitLabel: 'Court',
      amenities: ['Air circulation', 'Glare-free lights', 'Racket rental', 'Shuttle sale', 'Seating', 'Lockers'],
      rules: [
        'Non-marking indoor shoes are mandatory.',
        'Maximum 4 players on court.',
        'Bring your own shuttles or buy at the desk.',
        'Free cancellation up to 2 hours before your slot.',
      ],
      badge: 'Indoor',
    ),
    Facility(
      id: 'practice-nets',
      name: 'Power Nets',
      headline: 'Two-lane Cricket Practice Nets',
      kind: FacilityKind.practiceNets,
      sports: [SportType.cricketNets],
      description:
          'Two independent practice lanes with true-bounce astro pitch strips. Book one lane for solo '
          'batting or both for a full team session. Bowling machine available on request.',
      pricePerHour: 500,
      peakPricePerHour: 700,
      rating: 4.6,
      reviewCount: 142,
      openHour: 6,
      closeHour: 22,
      surface: 'Astro-turf pitch strips',
      dimensions: '2 lanes × 70 ft',
      maxPlayers: 6,
      units: 2,
      unitLabel: 'Lane',
      amenities: ['Bowling machine', 'Side netting', 'Floodlights', 'Kit storage', 'Video analysis', 'Water'],
      rules: [
        'Helmets are mandatory while batting.',
        'Leather or synthetic balls only.',
        'Prices are per lane, per hour.',
        'Free cancellation up to 2 hours before your slot.',
      ],
      badge: 'Bowling machine',
    ),
  ];

  static DateTime _today() => DateTime.now().dateOnly;

  static DateTime _nextWeekday(int weekday) {
    final today = _today();
    var d = today;
    while (d.weekday != weekday) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  /// Next daily occurrence of `hour:minute` (today if it hasn't started yet).
  static DateTime _nextDaily(int hour, [int minute = 0]) {
    final candidate = _today().add(Duration(hours: hour, minutes: minute));
    return candidate.isAfter(DateTime.now()) ? candidate : candidate.add(const Duration(days: 1));
  }

  static List<ArenaEvent> events() {
    final sunrise = _nextDaily(6, 30);
    final social = _nextDaily(19);
    final master = _nextDaily(17);
    final sunday = _nextWeekday(DateTime.sunday);
    final saturday = _nextWeekday(DateTime.saturday);
    return [
      ArenaEvent(
        id: 'ev-sunrise-cricket',
        title: 'Sunrise Box Cricket',
        subtitle: 'Daily · 6:30 AM',
        description:
            'Start your day with a fast-paced box cricket mixer. Teams are balanced on arrival — '
            'just show up solo or with a friend and play 3 quick 5-over matches.',
        cadence: EventCadence.daily,
        sport: SportType.cricket,
        start: sunrise,
        end: sunrise.add(const Duration(minutes: 90)),
        venue: 'The Dino Box',
        fee: 149,
        capacity: 16,
        registered: 9,
        level: 'All levels',
        highlights: ['Balanced teams', 'Ball & stumps provided', 'Post-game chai'],
      ),
      ArenaEvent(
        id: 'ev-badminton-social',
        title: 'After-Work Badminton Social',
        subtitle: 'Daily · 7:00 PM',
        description:
            'Rotating doubles with players at your level. A host keeps courts moving so everyone gets '
            'plenty of games in two hours.',
        cadence: EventCadence.daily,
        sport: SportType.badminton,
        start: social,
        end: social.add(const Duration(hours: 2)),
        venue: 'Shuttle Dome',
        fee: 199,
        capacity: 12,
        registered: 10,
        level: 'Intermediate',
        highlights: ['Level-matched doubles', 'Shuttles included', 'Hosted session'],
      ),
      ArenaEvent(
        id: 'ev-nets-masterclass',
        title: 'Nets Masterclass',
        subtitle: 'Daily · 5:00 PM',
        description:
            'A coached nets session focused on technique. Includes bowling machine drills, video '
            'feedback on your stance and a personalised practice plan.',
        cadence: EventCadence.daily,
        sport: SportType.cricketNets,
        start: master,
        end: master.add(const Duration(minutes: 90)),
        venue: 'Power Nets',
        fee: 299,
        capacity: 8,
        registered: 3,
        level: 'Intermediate',
        highlights: ['Certified coach', 'Bowling machine', 'Video analysis'],
      ),
      ArenaEvent(
        id: 'ev-super-sunday',
        title: 'Super Sunday 6-a-side',
        subtitle: 'Weekend · Sunday 4:00 PM',
        description:
            'Our flagship weekend football mixer. Six teams, round-robin format and a final under the '
            'floodlights. Bibs, ball and referee provided.',
        cadence: EventCadence.weekend,
        sport: SportType.football,
        start: sunday.add(const Duration(hours: 16)),
        end: sunday.add(const Duration(hours: 19)),
        venue: 'The Dino Box',
        fee: 249,
        capacity: 36,
        registered: 22,
        level: 'All levels',
        highlights: ['Referee', 'Bibs provided', 'Floodlit final'],
      ),
      ArenaEvent(
        id: 'ev-floodlit-smash',
        title: 'Saturday Floodlit Smash',
        subtitle: 'Weekend · Saturday 8:00 PM',
        description:
            'Night box cricket with music, live scoring and a man-of-the-match award. Fast 6-over games, '
            'all evening.',
        cadence: EventCadence.weekend,
        sport: SportType.cricket,
        start: saturday.add(const Duration(hours: 20)),
        end: saturday.add(const Duration(hours: 23)),
        venue: 'The Dino Box',
        fee: 299,
        capacity: 32,
        registered: 30,
        level: 'Competitive',
        highlights: ['Live scoring', 'DJ & music', 'MOTM award'],
      ),
      ArenaEvent(
        id: 'ev-junior-camp',
        title: 'Junior Dinos Cricket Camp',
        subtitle: 'Weekend · Saturday 8:00 AM',
        description: 'Fun, structured cricket coaching for ages 8–14 in the practice nets.',
        cadence: EventCadence.weekend,
        sport: SportType.cricketNets,
        start: saturday.add(const Duration(hours: 8)),
        end: saturday.add(const Duration(hours: 10)),
        venue: 'Power Nets',
        fee: 399,
        capacity: 20,
        registered: 20,
        level: 'Ages 8–14',
        highlights: ['Coach-led', 'Kit provided', 'Progress card'],
      ),
    ];
  }

  static List<Tournament> tournaments() {
    final t = _today();
    return [
      Tournament(
        id: 'tr-premier-league',
        name: 'DinoArena Premier League',
        tagline: 'The city’s biggest box cricket league',
        sport: SportType.cricket,
        format: '8-over league + knockouts',
        startDate: t.add(const Duration(days: 12)),
        endDate: t.add(const Duration(days: 20)),
        registrationCloses: t.add(const Duration(days: 9)),
        entryFee: 3999,
        prizePool: 50000,
        teamSize: 8,
        maxTeams: 16,
        registeredTeams: 11,
        status: TournamentStatus.open,
        prizes: ['Winner · ₹30,000 + trophy', 'Runner-up · ₹15,000', 'Player of the tournament · ₹5,000'],
        rules: [
          '8 players per squad (6 on field + 2 subs).',
          '8 overs per innings, max 2 overs per bowler.',
          'Tennis ball cricket, box rules apply.',
          'Entry fee is non-refundable after fixtures are published.',
        ],
      ),
      Tournament(
        id: 'tr-champions-cup',
        name: 'Box Football Champions Cup',
        tagline: '5-a-side knockout under the floodlights',
        sport: SportType.football,
        format: '5-a-side knockout',
        startDate: t.add(const Duration(days: 6)),
        endDate: t.add(const Duration(days: 7)),
        registrationCloses: t.add(const Duration(days: 2)),
        entryFee: 2999,
        prizePool: 30000,
        teamSize: 7,
        maxTeams: 12,
        registeredTeams: 10,
        status: TournamentStatus.closingSoon,
        prizes: ['Winner · ₹20,000 + trophy', 'Runner-up · ₹8,000', 'Golden boot · ₹2,000'],
        rules: [
          '7 players per squad (5 on field + 2 rolling subs).',
          '2 × 12 minute halves, knockout format.',
          'Turf shoes only — no metal studs.',
        ],
      ),
      Tournament(
        id: 'tr-smash-open',
        name: 'Smash Open Doubles',
        tagline: 'Open doubles badminton championship',
        sport: SportType.badminton,
        format: 'Doubles · group + knockout',
        startDate: t.add(const Duration(days: 18)),
        endDate: t.add(const Duration(days: 19)),
        registrationCloses: t.add(const Duration(days: 14)),
        entryFee: 999,
        prizePool: 15000,
        teamSize: 2,
        maxTeams: 32,
        registeredTeams: 14,
        status: TournamentStatus.open,
        prizes: ['Winners · ₹10,000', 'Runners-up · ₹5,000'],
        rules: ['Best of 3 games to 21 points.', 'Feather shuttles provided for knockouts.', 'BWF rules apply.'],
      ),
      Tournament(
        id: 'tr-power-hitting',
        name: 'Power-Hitting Challenge',
        tagline: 'Who clears the nets the most?',
        sport: SportType.cricketNets,
        format: 'Individual · 12 balls',
        startDate: t.add(const Duration(days: 3)),
        endDate: t.add(const Duration(days: 3)),
        registrationCloses: t.add(const Duration(days: 1)),
        entryFee: 299,
        prizePool: 10000,
        teamSize: 1,
        maxTeams: 40,
        registeredTeams: 40,
        status: TournamentStatus.full,
        prizes: ['Top hitter · ₹6,000', '2nd · ₹3,000', '3rd · ₹1,000'],
        rules: ['12 balls from the bowling machine at 110 km/h.', 'Points for distance zones.'],
      ),
      Tournament(
        id: 'tr-midweek-league',
        name: 'Midweek Turf League',
        tagline: 'Round 2 fixtures are live now',
        sport: SportType.football,
        format: '6-a-side league',
        startDate: t.subtract(const Duration(days: 2)),
        endDate: t.add(const Duration(days: 5)),
        registrationCloses: t.subtract(const Duration(days: 4)),
        entryFee: 2499,
        prizePool: 20000,
        teamSize: 8,
        maxTeams: 8,
        registeredTeams: 8,
        status: TournamentStatus.live,
        prizes: ['Winner · ₹15,000', 'Runner-up · ₹5,000'],
        rules: ['League format, 3 points for a win.'],
      ),
    ];
  }

  static List<Booking> seedBookings() {
    final t = _today();
    final tomorrow = t.add(const Duration(days: 1));
    final lastWeek = t.subtract(const Duration(days: 5));
    return [
      Booking(
        id: 'bk-seed-1',
        code: 'DINO-7K4P2Q',
        kind: BookingKind.slot,
        title: 'Box Cricket · The Dino Box',
        venue: 'The Dino Box',
        sport: SportType.cricket,
        start: tomorrow.add(const Duration(hours: 19)),
        end: tomorrow.add(const Duration(hours: 21)),
        amountPaid: 3776,
        status: BookingStatus.confirmed,
        createdAt: t.subtract(const Duration(days: 1)),
        referenceId: 'box-turf',
        unitLabel: 'Turf',
        paymentId: 'pay_demo_9XL2',
        slotLabels: ['7 PM – 8 PM', '8 PM – 9 PM'],
        players: 12,
      ),
      Booking(
        id: 'bk-seed-2',
        code: 'DINO-3M8B1Z',
        kind: BookingKind.slot,
        title: 'Badminton · Shuttle Dome',
        venue: 'Shuttle Dome',
        sport: SportType.badminton,
        start: lastWeek.add(const Duration(hours: 7)),
        end: lastWeek.add(const Duration(hours: 8)),
        amountPaid: 472,
        status: BookingStatus.completed,
        createdAt: lastWeek.subtract(const Duration(days: 1)),
        referenceId: 'badminton-court',
        unitLabel: 'Court',
        paymentId: 'pay_demo_4QW1',
        slotLabels: ['7 AM – 8 AM'],
        players: 4,
      ),
      Booking(
        id: 'bk-seed-3',
        code: 'DINO-9T2R6C',
        kind: BookingKind.slot,
        title: 'Cricket Nets · Power Nets',
        venue: 'Power Nets',
        sport: SportType.cricketNets,
        start: lastWeek.add(const Duration(days: 2, hours: 18)),
        end: lastWeek.add(const Duration(days: 2, hours: 19)),
        amountPaid: 826,
        status: BookingStatus.cancelled,
        createdAt: lastWeek,
        referenceId: 'practice-nets',
        unitLabel: 'Lane A',
        slotLabels: ['6 PM – 7 PM'],
        players: 2,
      ),
    ];
  }

  static List<AppNotification> notifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n-1',
        title: 'Your game is tomorrow',
        body: 'Box Cricket at The Dino Box · 7 PM. Show your DinoArena pass at the gate.',
        type: NotificationType.booking,
        createdAt: now.subtract(const Duration(minutes: 25)),
        deepLink: '/bookings',
      ),
      AppNotification(
        id: 'n-2',
        title: 'Champions Cup closing soon',
        body: 'Only 2 team spots left in the Box Football Champions Cup. Register before entries close.',
        type: NotificationType.tournament,
        createdAt: now.subtract(const Duration(hours: 3)),
        deepLink: '/tournament/tr-champions-cup',
      ),
      AppNotification(
        id: 'n-3',
        title: 'Weekend floodlit smash',
        body: 'Saturday Floodlit Smash is 94% full — grab one of the last spots.',
        type: NotificationType.event,
        createdAt: now.subtract(const Duration(hours: 20)),
        deepLink: '/event/ev-floodlit-smash',
      ),
      AppNotification(
        id: 'n-4',
        title: 'Payment received',
        body: '₹3,776 paid for your Box Cricket booking. Booking ID DINO-7K4P2Q.',
        type: NotificationType.payment,
        createdAt: now.subtract(const Duration(days: 1)),
        read: true,
      ),
      AppNotification(
        id: 'n-5',
        title: 'Use code DINO10',
        body: 'Get 10% off your next off-peak booking on any DinoArena facility.',
        type: NotificationType.promo,
        createdAt: now.subtract(const Duration(days: 3)),
        read: true,
      ),
    ];
  }
}
