package com.zcunsoft.cfg;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.HashMap;


@ConfigurationProperties("init")
public class InitSetting {

    private String logDb = "clklog";

    private String resourcePath = "";

    private int eventSessionAcrossDay = 2;

    private boolean quartzEnabled = true;


    private int sleepMillisecAfterOneRound = 300000;


    private int sleepMillisecAfterOneScript = 2000;

    private HashMap<String, String> quartz;

    public String getResourcePath() {
        return resourcePath;
    }

    public void setResourcePath(String resourcePath) {
        this.resourcePath = resourcePath;
    }

    public boolean isQuartzEnabled() {
        return quartzEnabled;
    }

    public void setQuartzEnabled(boolean quartzEnabled) {
        this.quartzEnabled = quartzEnabled;
    }

    public HashMap<String, String> getQuartz() {
        return quartz;
    }

    public void setQuartz(HashMap<String, String> quartz) {
        this.quartz = quartz;
    }

    public String getLogDb() {
        return sanitizeLogDb(logDb);
    }

    public void setLogDb(String logDb) {
        this.logDb = sanitizeLogDb(logDb);
    }

    /**
     * 仅允许字母数字下划线，防止库名注入 SQL。
     */
    private static String sanitizeLogDb(String logDb) {
        if (logDb == null || logDb.trim().isEmpty()) {
            return "clklog";
        }
        String trimmed = logDb.trim();
        if (!trimmed.matches("^[A-Za-z0-9_]+$")) {
            throw new IllegalArgumentException("invalid init.log-db: " + logDb);
        }
        return trimmed;
    }

    public int getSleepMillisecAfterOneScript() {
        return sleepMillisecAfterOneScript;
    }

    public void setSleepMillisecAfterOneScript(int sleepMillisecAfterOneScript) {
        this.sleepMillisecAfterOneScript = sleepMillisecAfterOneScript;
    }

    public int getSleepMillisecAfterOneRound() {
        return sleepMillisecAfterOneRound;
    }

    public void setSleepMillisecAfterOneRound(int sleepMillisecAfterOneRound) {
        this.sleepMillisecAfterOneRound = sleepMillisecAfterOneRound;
    }

    public int getEventSessionAcrossDay() {
        return eventSessionAcrossDay;
    }

    public void setEventSessionAcrossDay(int eventSessionAcrossDay) {
        this.eventSessionAcrossDay = eventSessionAcrossDay;
    }
}
