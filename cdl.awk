#!/usr/bin/awk 2>/dev/null -f

function timestamp_to_date(timestamp)
{
    format = "%Y-%m-%dT%H:%M"
    return strftime(format, timestamp);
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


function add_succes_code(code,    i, X_index) #the extra space before i and X_index is a coding convention to indicate that they are local variables, not an arguments
{
    code = toupper(code); # nu imi mergea codul ca peste tot scria X dar in checker e x, si eu nu facusem ca in checker... e 03:43, ca sa ma ai pe constiinta
    X_index = index(code, "X");
    if (X_index) { #if X exists in code
        for(i = 0; i <= 9; i++) {
            add_succes_code(substr(code, 1, X_index - 1) i substr(code, X_index + 1));
        }
    } else {
        succes_codes_array[code] = "1";
    }
}

BEGIN {
    ji = 1;
    start_tm = 0;
    end_tm = 292277026600;
    interval = 60;
    succes_codes_string = "2XX";
    for (i = 0; i < ARGC - 1; i++) {
        if (ARGV[i] == "--start") {
            start_tm = date_to_timestamp(ARGV[i+1]);
        }
        if (ARGV[i] == "--end") {
            end_tm = date_to_timestamp(ARGV[i+1]);
        }
        if (ARGV[i] == "--interval") {
            interval = ARGV[i + 1] * 60;
        }
        if (ARGV[i] == "--success") {
            succes_codes_string = ARGV[i + 1];
        }
    }
    while (succes_codes_string != "") {
        succes_code_len = index(succes_codes_string, ",") - 1;
        if (succes_code_len == -1) { # there was no "," left
            add_succes_code(succes_codes_string);
            succes_codes_string = "";
        } else {
            add_succes_code(substr(succes_codes_string, 1, succes_code_len));
            succes_codes_string = substr(succes_codes_string, succes_code_len + 2); # ignore "," and start from next digit
        }
    }
    ARGC = 2; # only treat ARGV[1] as a file
    
    month_to_nr["Jan"] = "01";
    month_to_nr["Feb"] = "02";
    month_to_nr["Mar"] = "03";
    month_to_nr["Apr"] = "04";
    month_to_nr["May"] = "05";
    month_to_nr["Jun"] = "06";
    month_to_nr["Jul"] = "07";
    month_to_nr["Aug"] = "08";
    month_to_nr["Sep"] = "09";
    month_to_nr["Oct"] = "10";
    month_to_nr["Nov"] = "11";
    month_to_nr["Dec"] = "12";
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
    month = month_to_nr[month];
    year = substr(raw_date, 8, 4);
    hour = substr(raw_date, 13, 2);
    minute = substr(raw_date, 16, 2);
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
        #for some reasons if(int(status_code / 100) == 2 && status_code > 99 && status_code < 1000) stats_succes[code_name]++; was a bug
        #but if (int(status_code / 100) == 2 && status_code >= 100 && status_code <= 999) stats_succes[code_name]++; was not
        #email only.god@knows.why for more information
        if (status_code in succes_codes_array) {
            stats_succes[code_name]++;
        }
        # }
    }
}

# possible optimization: when start_date > end_tm, print stats and finish the execution

END {
    PROCINFO["sorted_in"] = "@ind_str_asc"

    for (i in stats_total) {
        date = substr(i, 1, 16);
        endpoint = substr(i, 18);
        printf("%s %d %s %3.2f\n", date, interval/60, endpoint, stats_succes[i] * 100 / stats_total[i]);
    }
}


