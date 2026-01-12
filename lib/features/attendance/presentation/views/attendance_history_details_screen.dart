import 'package:blue_bird/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/strings_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AttendanceHistoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? arguments;

  const AttendanceHistoryDetailsScreen({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    final trainerId = arguments?['trainerId'];
    final teamId = arguments?['teamId'];
    final teamName = arguments?['teamName'];

    if (trainerId == null || teamId == null) {
      return const Scaffold(body: Center(child: Text('Missing parameters')));
    }

    return BlocProvider(
      create: (_) => GetIt.I<AttendanceCubit>()..getHistory(trainerId, teamId),
      child: _DetailsBody(teamName: teamName),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final String teamName;

  const _DetailsBody({required this.teamName});

  String _format(Timestamp t) {
    final d = t.toDate();
    return "${d.day}/${d.month}/${d.year} • ${d.hour}:${d.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {
                if (state is AttendanceHistoryLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: ColorManager.primary),
                  );
                }

                if (state is AttendanceHistoryLoaded) {
                  if (state.history.isEmpty) {
                    return Center(
                        child: Text(StringsManager.noHistoryYet.tr()));
                  }

                  final grouped = <Timestamp, List>{};
                  for (final h in state.history) {
                    grouped.putIfAbsent(h.takenAt, () => []).add(h);
                  }

                  final dates = grouped.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: dates.map((date) {
                      return _HistoryCard(
                        title: _format(date),
                        records: grouped[date]!,
                      );
                    }).toList(),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final List records;

  const _HistoryCard({required this.title, required this.records});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: _DateHeader(title),
        children: records.map((r) {
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            title: Text(
              r.playerName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: _StatusBadge(status: r.status),
          );
        }).toList(),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _statusColor(status),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader(this.date);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorManager.primary.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.calendar_month,
            color: ColorManager.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

String _statusText(String s) {
  switch (s) {
    case 'present':
      return 'حاضر';
    case 'late':
      return 'متأخر';
    case 'absent':
      return 'غائب';
    default:
      return s;
  }
}

Color _statusColor(String s) {
  switch (s) {
    case 'present':
      return Colors.green;
    case 'late':
      return Colors.orange;
    case 'absent':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorManager.primary, ColorManager.lightPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringsManager.attendanceHistory.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
