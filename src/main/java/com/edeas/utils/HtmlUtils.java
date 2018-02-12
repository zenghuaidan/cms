package com.edeas.utils;

import java.util.ArrayList;
import java.util.List;

public class HtmlUtils {
	public static String timeOptions(int start, int end, int current) {
	    List<String> options = new ArrayList<String>();
	    for (int i = start; i <= end; i++)
	    {
	        String xp = ((i < 10) ? "0" : "") + i;
	        String sel = (i == current) ? " selected" : "";
	        options.add("<option value='" + i + "'" + sel + ">" + xp + "</option>");
	    }
	    return String.join("\r\n", options);
	}
}
