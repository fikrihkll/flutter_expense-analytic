import 'package:expense_app/features/data/models/floor/fund_sources_dto.dart';
import 'package:expense_app/features/data/models/floor/results/fund_source_result_dto.dart';
import 'package:floor/floor.dart';

@dao
abstract class FundSourceDao {

  @Query("SELECT fund_sources.id, SUM(expenses.nominal) as nominal, fund_sources.name, (fund_sources.daily_fund * DATEDIFF(:dateStart, :dateEnd)) as daily_fund, (fund_sources.weekly_fund * CAST((DATEDIFF(:dateStart, :dateEnd)/7) as INT)) as weekly_fund, fund_sources.monthly_fund, DATEDIFF(:dateStart, :dateEnd) as days, CAST((DATEDIFF(:dateStart, :dateEnd)/7) as INT) as weeks FROM expenses INNER JOIN fund_sources ON expenses.fund_source_id = fund_sources.id AND expenses.user_id = 1 AND expenses.date >= :dateStart AND expenses.date <= :dateEnd GROUP BY fund_sources.id")
  Future<List<FundSourceResultDTO>> getFundCalculation(String dateStart, String dateEnd);

  @Query("SELECT * FROM fund_sources")
  Future<List<FundSourcesDTO>> getFundSources();

  @insert
  Future<void> insertFundSource(FundSourcesDTO fundSource);
}