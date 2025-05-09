INSERT INTO ${CLKLOG_LOG_DB}.user_pv_bydate
SELECT ':cal_date' AS stat_date
	, If(t3.lib = '', 'all', t3.lib) AS lib
	, multiIf(t3.project_name = '', 'all', t3.project_name = 'N/A', '', t3.project_name) AS project_name
	, If(t3.is_first_day = '', 'all', t3.is_first_day) AS is_first_day
	, multiIf(t3.country = '', 'all', t3.country = 'N/A', '', t3.country) AS country
	, multiIf(t3.province = '', 'all', t3.province = 'N/A', '', t3.province) AS province
	, t3.pv0_uv, t3.pv1_uv, t3.pv2_5_uv, t3.pv6_10_uv, t3.pv11_20_uv
	, t3.pv21_30_uv, t3.pv31_40_uv, t3.pv41_50_uv, t3.pv51_100_uv, t3.pv101_uv
	, NOW() AS update_time
FROM (
	SELECT lib, project_name, is_first_day
		, if(country = '', 'N/A', country) AS country
		, if(province = '', 'N/A', province) AS province
		, countDistinct(if(pv = 0, distinct_id, NULL)) AS pv0_uv
		, countDistinct(if(pv = 1, distinct_id, NULL)) AS pv1_uv
		, countDistinct(if(pv >= 2
			AND pv <= 5, distinct_id, NULL)) AS pv2_5_uv
		, countDistinct(if(pv >= 6
			AND pv <= 10, distinct_id, NULL)) AS pv6_10_uv
		, countDistinct(if(pv >= 11
			AND pv <= 20, distinct_id, NULL)) AS pv11_20_uv
		, countDistinct(if(pv >= 21
			AND pv <= 30, distinct_id, NULL)) AS pv21_30_uv
		, countDistinct(if(pv >= 31
			AND pv <= 40, distinct_id, NULL)) AS pv31_40_uv
		, countDistinct(if(pv >= 41
			AND pv <= 50, distinct_id, NULL)) AS pv41_50_uv
		, countDistinct(if(pv >= 51
			AND pv <= 100, distinct_id, NULL)) AS pv51_100_uv
		, countDistinct(if(pv >= 101, distinct_id, NULL)) AS pv101_uv
	FROM (
		SELECT lib, project_name, is_first_day, country, province
			, distinct_id, count(t1.pv) AS pv
		FROM (
			SELECT lib, project_name, is_first_day, country, province
				, distinct_id
				, multiIf(lib = 'js'
					AND event = '$pageview', event, lib IN ('iOS', 'Android')
					AND event = '$AppViewScreen', event, lib = 'MiniProgram'
					AND event = '$MPViewScreen', event, NULL) AS pv
			FROM ${CLKLOG_LOG_DB}.log_analysis
			WHERE stat_date = ':cal_date'
		) t1
		GROUP BY lib, project_name, is_first_day, country, province, distinct_id
	) t2
	GROUP BY lib, project_name, is_first_day, country, province WITH CUBE
) t3
