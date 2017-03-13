#!/usr/bin/awk 2>/dev/null -f

function timestamp_to_date(timestamp)
{
    format = "%Y-%m-%dT%H:%M"
    return strftime(format, timestamp);
}



function month_to_nr(month)
{
	if (month == "Jan")
		month = "01"
	else if (month == "Feb")
		month = "02"
	else if (month == "Mar")
		month = "03"
	else if (month == "Apr")
		month = "04"
	else if (month == "May")
		month = "05"
	else if (month == "Jun")
		month = "06"
	else if (month == "Jul")
		month = "07"
	else if (month == "Aug")
		month = "08"
	else if (month == "Sep")
		month = "09"
	else if (month == "Oct")
		month = "10"
	else if (month == "Nov")
		month = "11"
	else if (month == "Dec")
		month = "12"
    return month
}

function date_to_timestamp(date)
{
    year = substr(date, 1, 4);
    month = substr(date, 6, 2);
    day = substr(date, 9, 2);
    hour = substr(date, 12, 2);
    minute = substr(date, 15, 2);
    second = "00"
	datespec = year " " month " " day " " hour " " minute " " second;
	timestamp = mktime(datespec);
    return timestamp;
}


BEGIN {
    ji = 1;
    start_tm = 0
    end_tm = 292277026600
    interval = 60
    for (i =0; i < ARGC - 1; i++) {
        if (ARGV[i] == "--start") {
            start_tm = date_to_timestamp(ARGV[i+1]);
        }
        if (ARGV[i] == "--end") {
            end_tm = date_to_timestamp(ARGV[i+1]);
        }
        if (ARGV[i] == "--interval") {
            interval = ARGV[i + 1] * 60;
        }
    }
    ARGC = 2; # don't treet all arguments as files
}




{
    # get raw date from line {
    line = $0;
    sdate = index(line, "[") + 1;
    edate = index(line, "]") - 1;
    lendate = edate - sdate + 1;
    raw_date = substr(line, sdate, lendate);
    # }
    # parse raw date {
    day = substr(raw_date, 1, 2);
    month = substr(raw_date, 4, 3);
    month = month_to_nr(month);
    year = substr(raw_date, 8, 4);
    hour = substr(raw_date, 13, 2);
    minute = substr(raw_date, 16, 2);
    # second = substr(raw_date, 19, 2); # seconds are not ignored
    second = "00" # seconds are ignored
    GMTH = substr(raw_date, 22, 3);
    GMTM = substr(raw_date, 22, 1) substr(raw_date, 25, 2);
    hour += GMTH
    minute += GMTM #e corect?
    datespec = year " " month " " day " " hour " " minute " " second;
    timestamp = mktime(datespec);
    # }
    if (timestamp >= start_tm && timestamp <= end_tm) {
        # get endpoint and status code from line {
        regex = "\"[^\"]*\""
        if (match(line, regex)) {
            pattern = substr(line, RSTART, RLENGTH);
            after = substr(line, RSTART + RLENGTH + 1); #+1 ca scap de un spatiu 
            regex = "\/[^ ?#]*[ ?#]";
            if (match(pattern,regex)) {
                endpoint = substr(pattern, RSTART, RLENGTH - 1); #-1 ca sa elimin [ ?#]
            }
        }
        len_status_code = index(after, " ") - 1; #-1 ca sa scpa de un spatiu
        status_code = substr(after, 1, len_status_code);
        # }
        # update stats {
        if (!(endpoint in last_entry) || timestamp - last_entry[endpoint] >= interval) {
            last_entry[endpoint] = timestamp;
        }
        date = timestamp_to_date(last_entry[endpoint]);
        code_name = date "," endpoint;
        if (!(code_name in stats_total)) {
            stats_total[code_name] = 1;
            stats_succes[code_name] = 0;
        } else {
        stats_total[code_name]++;
        }
        #for some reasons status_code > 99 && status code < 1000 was a bug. email only.god@knows.why for more information
        if (int(status_code / 100) == 2 && status_code >= 100 && status_code <= 999) {
            stats_succes[code_name]++;
        }
        # }
    }
}

END {
    PROCINFO["sorted_in"] = "@ind_str_asc"

    for (i in stats_total) {
        date = substr(i, 1, 16);
        endpoint = substr(i, 18);
        printf("%s %d %s %3.2f\n", date, interval/60, endpoint, stats_succes[i] * 100 / stats_total[i]);
    }
}


