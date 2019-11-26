package org.openas2.processor.sender;

import org.openas2.OpenAS2Exception;
import org.openas2.util.HTTPUtil;

import java.util.HashMap;
import java.util.Map;

public abstract class HttpSenderModule extends BaseSenderModule implements SenderModule {

    public static final String PARAM_READ_TIMEOUT = "readtimeout";
    public static final String PARAM_CONNECT_TIMEOUT = "connecttimeout";

    // private Log logger = LogFactory.getLog(HttpSenderModule.class.getSimpleName());

    public Map<String, String> getHttpOptions() throws OpenAS2Exception {
        Map<String, String> options = new HashMap<String, String>();
        options.put(HTTPUtil.PARAM_READ_TIMEOUT, getParameter(PARAM_READ_TIMEOUT, "60000"));
        options.put(HTTPUtil.PARAM_CONNECT_TIMEOUT, getParameter(PARAM_CONNECT_TIMEOUT, "60000"));
        return options;
    }
}
