// import 'dart:ui';
// import 'package:blue_bird/core/di/di.dart';
// import 'package:blue_bird/core/router/app_routes.dart';
// import 'package:blue_bird/features/add_team/domain/entities/player_entity.dart';
// import 'package:blue_bird/features/attendance/presentation/views/attendance_histoy_view.dart';
// import 'package:blue_bird/features/home/presentation/widgets/session_card.dart';
// import 'package:blue_bird/utils/text_styles.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:blue_bird/features/home/presentation/cubit/home_cubit.dart';
// import 'package:blue_bird/utils/color_manager.dart';
// import 'package:blue_bird/utils/strings_manager.dart';
// import 'package:blue_bird/utils/values_manager.dart';

// class SessionViewBody extends StatelessWidget {
//   final String trainerId;
//   final String teamId;
//   final List<PlayerEntity> players;

//   const SessionViewBody({
//     super.key,
//     required this.trainerId,
//     required this.teamId,
//     required this.players,
//   });

//   Widget _buildHeader(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeOut,
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       decoration: const BoxDecoration(
//         color: ColorManager.primary,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(40),
//           bottomRight: Radius.circular(40),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               StringsManager.sessions.tr(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.close, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cubit = getIt<HomeCubit>();
//     cubit.getSessions(trainerId, teamId);

//     return Column(
//       children: [
//         _buildHeader(context),
//         Expanded(
//           child: BlocBuilder<HomeCubit, HomeState>(
//             bloc: cubit,
//             builder: (context, state) {
//               if (state is SessionLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is SessionsLoaded) {
//                 final sessions = state.sessions;
//                 if (sessions.isEmpty) {
//                   return Container(
//                     color: Colors.grey.shade50,
//                     child:
//                         Center(child: Text(StringsManager.noSessionsYet.tr())),
//                   );
//                 }

//                 return Container(
//                   color: Colors.grey.shade50,
//                   child: ListView.builder(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: AppPadding.p8),
//                     itemCount: sessions.length,
//                     itemBuilder: (context, index) {
//                       final session = sessions[index];
//                       final isUpcoming = session.status == 'upcoming';
//                       final statusText = isUpcoming ? 'Upcoming' : 'Completed';

//                       return TweenAnimationBuilder<Offset>(
//                         tween: Tween(
//                             begin: const Offset(0, 0.2), end: Offset.zero),
//                         duration: Duration(milliseconds: 300 + index * 100),
//                         curve: Curves.easeOut,
//                         builder: (_, offset, child) {
//                           return Transform.translate(
//                             offset: offset * 100,
//                             child: Opacity(
//                               opacity: 1 - offset.dy,
//                               child: child,
//                             ),
//                           );
//                         },
//                         child: SessionCard(
//                           dayName: session.day,
//                           date: session.date,
//                           time: session.time,
//                           status: statusText,
//                           isUpcoming: isUpcoming,
//                           onPressed: () {
//                             cubit.getSession(trainerId, teamId, session.id);
//                             Navigator.pushNamed(
//                               context,
//                               AppRoutes.attendanceScreen,
//                               arguments: {
//                                 'trainerId': trainerId,
//                                 'teamId': teamId,
//                                 'sessionId': session.id,
//                                 'players': players,
//                               },
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               } else if (state is SessionError) {
//                 return Container(
//                   color: Colors.grey.shade50,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(StringsManager.errorLoadingSessions.tr()),
//                         const SizedBox(height: AppSize.s16),
//                         ElevatedButton(
//                           onPressed: () {
//                             cubit.getSessions(trainerId, teamId);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorManager.primary,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: AppPadding.p12,
//                               horizontal: AppPadding.p20,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(AppSize.s12),
//                             ),
//                           ),
//                           child: Text(
//                             StringsManager.retry.tr(),
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }

//               return const SizedBox();
//             },
//           ),
//         ),
//         _buildHistoryButton(context),
//       ],
//     );
//   }

//   Widget _buildHistoryButton(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppPadding.p16),
//       color: Colors.white,
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.history, color: Colors.white),
//           label: Text(
//             StringsManager.history.tr(),
//             style: AppTextStyles.font14W800White(context),
//           ),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: ColorManager.primary,
//             padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(AppSize.s12),
//             ),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => AttendanceHistoryScreen(
//                   trainerId: trainerId,
//                   teamId: teamId,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
