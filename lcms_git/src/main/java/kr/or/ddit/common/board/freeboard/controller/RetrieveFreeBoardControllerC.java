package kr.or.ddit.common.board.freeboard.controller;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.common.board.freeboard.service.FreeBoardService;
import kr.or.ddit.enumpkg.ServiceResult;
import kr.or.ddit.utils.annotation.RealUser;
import kr.or.ddit.utils.paging.BootstrapFormBasePaginationRenderer;
import kr.or.ddit.utils.paging.PaginationInfo;
import kr.or.ddit.utils.paging.PaginationRenderer;
import kr.or.ddit.validate.UpdateGroup;
import kr.or.ddit.vo.common.ClubVO;
import kr.or.ddit.vo.common.CommunityVO;
import kr.or.ddit.vo.cyber.LectureDataVO;
import kr.or.ddit.vo.user.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("common/board/freeboard/")
public class RetrieveFreeBoardControllerC {
	
	@Inject
	private FreeBoardService service;

	@GetMapping("freeBoardList")
	public String list(
			@RequestParam Map<String, Object> detailCondition
			, @RequestParam(name="page", required = false, defaultValue = "1") int currentPage
			, Model model
			, @ModelAttribute("paging") PaginationInfo page
			
			) {
		PaginationInfo paging = new PaginationInfo(5,3);
		
		paging.setCurrentPage(currentPage);
		paging.setSimpleCondition(page.getSimpleCondition());
		paging.setDetailCondition(detailCondition);
		
		
		List<CommunityVO> list = service.retrieveFbList(paging);
		log.info("리스트인포:{}",list);
		PaginationRenderer renderer = new BootstrapFormBasePaginationRenderer("#submitForm");
		String pagingHTML = renderer.renderPagination(paging);
		
		int today = service.countBoard();
		int total = paging.getTotalRecord();
		

		model.addAttribute("total", total);
		model.addAttribute("today", today);
		model.addAttribute("list", list);
		model.addAttribute("pagingHTML", pagingHTML);
		model.addAttribute("condition", detailCondition);
		model.addAttribute("contentTitle", "자유게시판");
		
		return "tiles:common/board/freeboard/freeBoardList";
	}
	
	@GetMapping("freeBoardDetails")
	public String Details(
			 Model model
			, @RequestParam String cmntCode
			, @RealUser MemberVO mem
			
			) {
		
		
		CommunityVO b = service.retrieveFb(cmntCode);
		log.info("디테일:{}",b);
		model.addAttribute("b", b);
		model.addAttribute("contentTitle", "자유게시판");
		
		return "tiles:common/board/freeboard/freeBoardDetails";
	}
	
	@GetMapping("fbForm")
	public String goToForm(
			@RequestParam(name = "parentCmntCode", required = false) String parentCmntCode, Model model
			, @RealUser MemberVO mem
			) {
		
		String memName = mem.getMemName();
		model.addAttribute("memName",memName);
		log.info("부모글:{}",parentCmntCode);
		model.addAttribute("parentCmntCode", parentCmntCode);
		
		
		return "tiles:common/board/freeboard/freeBoardForm";
	}
	
	@PostMapping("fbForm.do")
	@ResponseBody
	public String form(
		@ModelAttribute CommunityVO newFb,
		Model model,
		BindingResult errors,
		@RealUser MemberVO mem
			) {
		String memNo = mem.getMemNo();
		newFb.setMemNo(memNo);
		String logicalViewName = null;
		if(!errors.hasErrors()) {
			ServiceResult result=service.createFb(newFb);
			log.info("게시글정보:{}",newFb);
			String message = null;
			switch(result) {
			case OK:
				logicalViewName = "redirect:/common/board/freeboard/freeBoardList";
				break;
			case FAIL:
				logicalViewName = "common/board/freeboard/fbForm";
				break;
			}
			model.addAttribute("message", message);
		}else {
			logicalViewName = "common/board/freeboard/fbForm";
		}
		return logicalViewName;
	}

	@GetMapping("delete/{cmntCode}")
	public String delete(
			@PathVariable String cmntCode
			) {
		

		
		service.removeFb(cmntCode);
		log.info("여기당{}",cmntCode);
		return "redirect:/common/board/freeboard/freeBoardList";
				
	}
	
//	http://localhost/lcms/common/board/fr0eeboard/updateForm/FB000015
	@GetMapping("updateForm/{cmntCode}")
	public String editForm(@PathVariable String cmntCode, Model model) {
		CommunityVO com = service.retrieveFb(cmntCode);
//		log.info("코드{}");
		model.addAttribute("com", com);
	    return "tiles:common/board/freeboard/freeBoardEditForm";
	}
	
	@PostMapping("updateForm.do")
	public String update(
	    @ModelAttribute CommunityVO vo,
	    Model model
	) {
		
		log.info("업데이트{}",vo);
	        service.modifyFb(vo);
	    return "redirect:/common/board/freeboard/freeBoardList";
	}
	
}
