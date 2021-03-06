package com.zltel.broadcast.threeone.schedule.service;

import com.zltel.broadcast.common.json.R;
import com.zltel.broadcast.threeone.schedule.bean.Schedule;
import com.zltel.broadcast.um.bean.SysUser;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface ScheduleService {
    public void addSchedule(Schedule schedule);
    public int updateSchedule(Schedule schedule);
    public int deleteSchedule(int id);
    public Schedule getSchedule(int id);

    public List<Schedule> queryEnableSchedule();
    public List<Schedule> queryEnableSchedule(SysUser user);

    public List<Schedule> queryThreeoneEnableSchedule(SysUser user);
    public List<Schedule> queryLifeEnableSchedule(SysUser user);
    public List<Schedule> queryDemocraticAppraisalEnableSchedule(SysUser user);

    public List<Schedule> queryThreeoneCompletedSchedule(SysUser user, int pageNum, int pageSize);
    public List<Schedule> queryLifeCompletedSchedule(SysUser user, int pageNum, int pageSize);
    public List<Schedule> queryDemocraticAppraisalCompletedSchedule(SysUser user, int pageNum, int pageSize);

    public Map<Integer, Object> countCompletedSchedule(SysUser user);

    public R importSchedules(MultipartFile file, SysUser user);

    public void addMembers(Schedule schedule, List<Map<String, Object>> members);
    public List<Map<String, Object>> queryScheduleMembers(Integer scheduleId);
    public List<Map<String, Object>> queryOrgMembers(Integer orgId);

    public List<Map<String, Object>> queryThreeoneParticipatedSchedule(String username, int pageNum, int pageSize);
    public List<Map<String, Object>> queryLifeParticipatedSchedule(String username, int pageNum, int pageSize);
    public List<Map<String, Object>> queryDemocraticAppraisalParticipatedSchedule(String username, int pageNum, int pageSize);

    public void scheduleSign(List<Map<String, Object>> participantLinks);
    public void scheduleSign(int scheduleId, int userId);

    public Map<String, Object> getSignInfo(Integer scheduleId, SysUser user);
}
