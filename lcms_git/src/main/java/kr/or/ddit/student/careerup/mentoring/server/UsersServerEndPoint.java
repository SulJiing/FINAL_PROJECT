package kr.or.ddit.student.careerup.mentoring.server;

import java.io.IOException;
import java.io.StringReader;
import java.util.Collections;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.websocket.EncodeException;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import kr.or.ddit.student.careerup.mentoring.server.config.ServerAppConfig;


@ServerEndpoint(value = "/usersServerEndpoint", configurator = ServerAppConfig.class)
@Component
public class UsersServerEndPoint {
	private static final Logger LOGGER = LoggerFactory.getLogger(UsersServerEndPoint.class);
	private static Set<Session> connectedAllUsers = Collections.synchronizedSet(new HashSet<Session>());

	// Spring bean과 연동하기 위해서는 ServerAppConfig를 configurator로 등록해주면 된다.
	/*
	 * @Resource(name="TestService") TestService testService;
	 */

	/**
	 * Handshaking 함수
	 *
	 * @param userSession 사용자 session
	 */
	@OnOpen
	public void handleOpen(Session userSession) {
		connectedAllUsers.add(userSession);
	}

	/**
	 * Message전달 함수
	 *
	 * @param message     메시지
	 * @param userSession 사용자 session
	 * @throws IOException
	 * @throws EncodeException
	 */
	@OnMessage
	public void handleMessage(String message, Session userSession) throws IOException, EncodeException {
		String username = (String) userSession.getUserProperties().get("username");

		JsonObject jsonObject = Json.createReader(new StringReader(message)).readObject();

		String connectionType = jsonObject.getString("connectionType");

		if ("firstConnection".equals(connectionType) && username == null) {
			// 맨 처음 접속 시,
			// 사용자의 이름을 가져옴
			username = jsonObject.getString("username");

			LOGGER.info(username + " is entered.");

			if (username != null && !isExisted(username)) {
				userSession.getUserProperties().put("username", username);

				for (Session session : connectedAllUsers) {
					session.getBasicRemote().sendText(buildJsonUserData(getUsers()));
				}
			} else {
				// username을 다시 입력하게하는 로직 넣기.
			}

		} else if ("chatConnection".equals(connectionType)) {
			// chatroomId로 또다른 webSocket url에 접근한다.
			// id generation으로 대체가능.
			String chatroomId = genRandom();

			// 다른 사용자와 대화하고자 시도할 때
			// 채팅룸 사용자 저장
			Set<Session> chatroomMembers = new HashSet<Session>();
			chatroomMembers.add(userSession);

			// 선택한 사용자를 사용자들 안에서 찾기.
			String connectingUser = jsonObject.getString("connectingUser");

			if (connectingUser != null && !username.equals(connectingUser)) {
				// 사용자들 중 선택한 유저와 연결
				for (Session session : connectedAllUsers) {
					if (connectingUser.equals(session.getUserProperties().get("username"))) {
						// 선택한 사용자면 chatroomMember로 추가.
						chatroomMembers.add(session);
					}
				}

				// chatroomMembers에게 room입장하라는 신호 보내기
				for (Session session : chatroomMembers) {

					session.getBasicRemote().sendText(Json.createObjectBuilder().add("enterChatId", chatroomId)
							.add("username", (String) session.getUserProperties().get("username")).build().toString());
				}
			}
		}
	}

	/**
	 * 연결을 끊기 직전에 호출되는 함수
	 *
	 * @param userSession
	 * @throws IOException
	 * @throws EncodeException
	 */
	// 예외처리 필요!
	@OnClose
	public void handleClose(Session userSession) throws IOException, EncodeException {

		String disconnectedUser = (String) userSession.getUserProperties().get("username");
		connectedAllUsers.remove(userSession);

		if (disconnectedUser != null) {
			Json.createObjectBuilder().add("disconnectedUser", disconnectedUser).build().toString();

			for (Session session : connectedAllUsers) {
				session.getBasicRemote().sendText(
						Json.createObjectBuilder().add("disconnectedUser", disconnectedUser).build().toString());
			}
		}
	}

	/**
	 * 연결되어있는 user정보를 가져오는 함수
	 *
	 * @return user set
	 */
	private Set<String> getUsers() {
		HashSet<String> returnSet = new HashSet<String>();

		for (Session session : connectedAllUsers) {
			if (session.getUserProperties().get("username") != null) {
				returnSet.add(session.getUserProperties().get("username").toString());
			}
			;
		}
		return returnSet;
	}

	/**
	 * 유저 정보가 담긴 Set<String>을 json으로 변환해주는 함수
	 *
	 * @param set
	 * @return jsondata
	 */
	private String buildJsonUserData(Set<String> set) {

		JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();

		for (String user : set) {
			jsonArrayBuilder.add(user);
		}
		return Json.createObjectBuilder().add("allUsers", jsonArrayBuilder).build().toString();
	}

	/**
	 * 동일한 username을 가진 user session이 있는지 확인하는 함수
	 *
	 * @param username 사용자이름
	 * @return 존재여부
	 */
	private boolean isExisted(String username) {
		// 이미 username을 가진 session이 있는지 검사.
		for (Session existedUser : connectedAllUsers) {
			if (username.equals(existedUser.getUserProperties().get("username"))) {
				return true;
			}
		}
		return false;
	}

	/**
	 * chatroomId를 위한 랜덤값을 생성하는 함수
	 *
	 * @return chatroomId
	 */
	private String genRandom() {
		String chatroomId = "";
		for (int i = 0; i < 8; i++) {
			chatroomId += (char) ((new Random().nextDouble() * 26) + 97);
		}
		return chatroomId;
	}

}
