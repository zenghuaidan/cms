package com.edeas.utils;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.Date;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import com.sun.mail.util.MailSSLSocketFactory;

public class MailUtils {

	final static String username = "larry.zeng@edeas.hk";
	final static String password = "zenglarr";
	final static String frommail = "larry.zeng@edeas.hk";
	final static String protocal = "smtp";
	final static String host = "smtp.edeas.hk";
	final static String port = "25";
	final static String socketFactoryPort = "";

	public static boolean sendmail(String toname, String tomail, String subject, String content,
			Map<String, String> fileMap, boolean useSSL, boolean useAuth)
			throws SQLException, ClassNotFoundException, UnsupportedEncodingException {
		boolean success = false;
		Session session = getSession(useSSL, useAuth);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress(frommail));
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailWithName(toname, tomail), false));
			msg.setSubject(new String(subject.getBytes(), Charset.forName("utf-8")));
			// msg.setContent(content, "text/html;charset=gb2312");
			msg.setSentDate(new Date());

			Multipart mt = new MimeMultipart();
			MimeBodyPart mbp = new MimeBodyPart();
			mbp.setContent(content, "text/html;charset=utf-8");
			mt.addBodyPart(mbp);
			if (fileMap != null && fileMap.size() > 0) {

				for (String name : fileMap.values()) {
					MimeBodyPart fbp = new MimeBodyPart();
					FileDataSource fds = new FileDataSource(fileMap.get(name));
					fbp.setDataHandler(new DataHandler(fds));
					fbp.setFileName(MimeUtility.encodeText(name));

					mt.addBodyPart(fbp);
				}
			}

			msg.setContent(mt);

			Transport.send(msg);
			success = true;
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return success;
	}

	public static boolean sendmail(String toname, String tomail, String subject, String content, boolean useSSL,
			boolean useAuth) {
		boolean success = false;
		Session session = getSession(useSSL, useAuth);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress(frommail));
			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailWithName(toname, tomail), false));		
			msg.setSubject(new String(subject.getBytes(), Charset.forName("utf-8")));
			msg.setContent(content, "text/html;charset=utf-8");
			msg.setSentDate(new Date());
			Transport.send(msg);
			success = true;
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return success;
	}

	private static String emailWithName(String name, String email) {
		return name + " <" + email + ">";
	}

	private static Session getSession(boolean useSSL, boolean useAuth) {
		Properties props = System.getProperties();
		if (useSSL) {
			// Security.addProvider(new
			// com.sun.net.ssl.internal.ssl.Provider());
			// props.setProperty("mail.smtp.socketFactory.class",
			// "javax.net.ssl.SSLSocketFactory");
			MailSSLSocketFactory sf = null;
			try {
				sf = new MailSSLSocketFactory();
			} catch (GeneralSecurityException e) {
			}
			sf.setTrustAllHosts(true);
			props.put("mail.smtp.ssl.enable", useSSL);
			props.put("mail.smtp.ssl.socketFactory", sf);
			props.put("mail.smtp.socketFactory.fallback", false);
			props.put("mail.smtp.socketFactory.port", socketFactoryPort);

		}
		props.put("mail.store.protocol", protocal);
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		props.put("mail.smtp.auth", useAuth);
		if (useAuth)
			return Session.getInstance(props, new Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username, password);
				}
			});
		else
			return Session.getInstance(props);
	}
}
