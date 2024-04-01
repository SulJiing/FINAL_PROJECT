package kr.or.ddit.manager.pro.subject.controller;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.validation.groups.Default;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.enumpkg.ServiceResult;
import kr.or.ddit.manager.pro.subject.service.SubjectDecisionServiceM;
import kr.or.ddit.student.careerup.mentoring.mentoringmentor.dao.RejectSelectBox;
import kr.or.ddit.utils.annotation.RealUser;
import kr.or.ddit.validate.UpdateGroup;
import kr.or.ddit.vo.cyber.SubjectVO;
import kr.or.ddit.vo.user.MemberVO;

@Controller
@RequestMapping("/manager/pro/subject")
public class SubjectListControllerM {

	@Inject
	SubjectDecisionServiceM service;
	
	@Inject
	RejectSelectBox dao;

	@GetMapping("subjectList")
	public String applList(@RequestParam Map<String, Object> detailCondition, Model model,
				@RealUser MemberVO mem
			){
			List<SubjectVO> subjectDecisionList = service.retrieveSubjectDecisionList();
			
			model.addAttribute("subjectDecisionList", subjectDecisionList);
			model.addAttribute("condition", detailCondition);
			model.addAttribute("contentTitle", "교과목 개설 신청 승인/반려");
		return "tiles:manager/pro/subject/subjectList";
	}
	
	@GetMapping("subjectDecisionEditForm/{subAppno}")
	public String applEditForm(@PathVariable String subAppno, Model model) {
		SubjectVO subject = service.retrieveSubjectAppl(subAppno);
		List<Map<String, Object>> rejectList = dao.selectSubbjectRejectList();
		model.addAttribute("subject", subject);
		model.addAttribute("rejectList", rejectList);
		return "manager/pro/subject/subjectDecisionEditForm";
	}

	@PostMapping(value ="subjectDecisionEditForm", consumes = MediaType.APPLICATION_JSON_VALUE)
	public String decisionProcess(			
			@Validated({ UpdateGroup.class, Default.class }) @RequestBody SubjectVO subjectVO,
			Errors errors, RedirectAttributes redirectAttributes, Model model) {
		
		String logicalViewName = null;
		if (!errors.hasErrors()) {
			ServiceResult result = service.modifySubjectDecision(subjectVO);
			String message = null;
			switch (result) {
			case OK:
				logicalViewName = "redirect:/manager/pro/subject/subjectList";
				break;
			default:
				logicalViewName = "manager/pro/subject/subjectDecisionEditForm";
				message = "잘못된 정보 포함";
				break;
			}
			model.addAttribute("message", message);

		} else {
			logicalViewName = "manager/pro/subject/subjectDecisionEditForm";
		}
		return logicalViewName;
	}
}
