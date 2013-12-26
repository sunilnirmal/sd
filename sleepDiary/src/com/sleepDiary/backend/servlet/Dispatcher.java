package com.sleepDiary.backend.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;






import java.io.InputStream;
import java.io.InputStreamReader;




//Servlet Support
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;










// log4j logging
import org.apache.log4j.Logger;

import com.sleepDiary.backend.aws.SimpleDB;
import com.sleepDiary.backend.crypt.Crypt;
import com.sleepDiary.backend.data.Packet;
import com.sleepDiary.backend.data.statusCodes;
import com.sleepDiary.backend.statusCodes.DBCodes;





/**
 * Servlet implementation class Dispatcher
 */
@WebServlet(description = "Recieves packets from mobiles", urlPatterns = { "/Dispatcher" })
public class Dispatcher extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	Logger logger;
    /**
     * Default constructor. 
     */
    public Dispatcher() {
        logger = Logger.getLogger(this.getClass());
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Packet packet = new Packet();
		returnErrorMsg(response,packet);
		if(checkHeaders(request,packet) == false ) {
			returnErrorMsg(response,packet);
		} else {
			if (processRequest(request,response,packet)) {
				returnStatus(response,packet);
			} else {
				returnErrorMsg(response,packet);
			}
		}
		
		
		
		
	}

	private void returnStatus(HttpServletResponse response, Packet packet) {
		try {
			response.setStatus(200);
			
			response.setHeader("statusCode", "Success");
			response.flushBuffer();
			
		} catch (IOException e) {
		
			e.printStackTrace();
		}
		
	}

	private boolean processRequest(HttpServletRequest request,
			HttpServletResponse response, Packet packet) {
		try {
			String data;
			
			//Remove this , as the data will be sent through the data body only
			if(request.getHeader("data") != null ) {
				data = request.getHeader("data");
			} else {
				data = this.getBody(request);
			}
			logger.info("In processRequest : Recv data from "+ data);
			// TODO: decrypt the data
			String userName = request.getHeader("userName");
			if(userName == null) {
				packet.setStatusCode(statusCodes.DATA_RESEND , "Data is Corrupted");
				return false;
			} else {
				packet.setUserName(userName);
			}
			packet.setData(data);
			if(packet.writeToDB()) {
				packet.setStatusCode(statusCodes.DATA_ADDED , "Data was added");
				return true;
			} else {
				packet.setStatusCode(statusCodes.DATA_RESEND , "Data could not be written into the DB");
			}
			
		} catch (IOException e) {
			logger.debug("Error reading the data packet from "+ request.getRemoteHost());
			
			return false;
		}
		
		
		return false;
	}
	
	public String getBody(HttpServletRequest request) throws IOException {

	    String body = null;
	    StringBuilder stringBuilder = new StringBuilder();
	    BufferedReader bufferedReader = null;

	    try {
	        InputStream inputStream = request.getInputStream();
	        if (inputStream != null) {
	            bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
	            char[] charBuffer = new char[128];
	            int bytesRead = -1;
	            while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
	                stringBuilder.append(charBuffer, 0, bytesRead);
	            }
	        } else {
	            stringBuilder.append("");
	        }
	    } catch (IOException ex) {
	        throw ex;
	    } finally {
	        if (bufferedReader != null) {
	            try {
	                bufferedReader.close();
	            } catch (IOException ex) {
	                throw ex;
	            }
	        }
	    }

	    body = stringBuilder.toString();
	    return body;
	}

	private void returnErrorMsg(HttpServletResponse response, Packet packet) {
		try {
			response.setStatus(200);
			
			response.setHeader("statusCode", packet.getStatusString());
			response.flushBuffer();
			
		} catch (IOException e) {
		
			e.printStackTrace();
		}
		
	}

	private boolean checkHeaders(HttpServletRequest request, Packet packet) {
		// Check for content headers
		logger.info("Checking headers ");
		if(request.getHeader("userName") == null && request.getHeader("TypeOfData") == null ) {
			packet.setStatusCode(statusCodes.DATA_CORRUPT,"Data packet is corrupt");
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Packet packet = new Packet();
		//returnErrorMsg(response,packet);
		logger.info("In Post");
		logger.info("Number of headers " + response.getHeaderNames().size());
		for(String headerName: response.getHeaderNames()) {
			logger.info("GOT " + headerName + " having " +response.getHeader(headerName) );
		}
		
		String body = getBody(request);
		logger.info("REcv body : " + body);
		String[] details = body.split(" ");
		
		if(details.length == 4 && details[0].equals("Tapdata")) {
			
			String userName = details[1];
			String tapTime = details[2];
			String tapNumber = details[3];
			if(SimpleDB.addTap(userName, new Long(tapTime), tapNumber) == DBCodes.TAP_ADDED) {
				packet.setStatusCode(statusCodes.DATA_ADDED, "Data was added");
				returnStatus(response,packet);
			} else {
				packet.setStatusCode(statusCodes.DATA_RESEND, "Data was not added");
				returnErrorMsg(response,packet);
			}
			
		} else {
			if(checkHeaders(request,packet) == false ) {
				logger.error("Headers are not in place ");
				returnErrorMsg(response,packet);
			} else {
				if (processRequest(request,response,packet)) {
					returnStatus(response,packet);
				} else {
					logger.error("Processing requests failed ");
					returnErrorMsg(response,packet);
				}
			}
		}
		
	}

}
