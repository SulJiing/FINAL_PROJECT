package kr.or.ddit.professor.cyber.lecturenotice.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("professor/cyber/{lecCode}/lectureNoticeUpdate/{lecannNo}")
public class LectureNoticeUpdateControllerP {
	
	@GetMapping()
	public String lectureNoticeUpdate(@PathVariable String lecCode, @PathVariable String lecannNo) {
		return "professor/cyber/lecturenotice/lectureNoticeEdit";
	}

}
