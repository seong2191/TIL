package SeongYun.submit15.jdbc;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

// Connection 객체를 만들어주는 공장 클래스
public class ConnectionFactory2 {

	private String driver;
	private String url;
	private String id;
	private String password;
	private int maxConn;

	private static ConnectionFactory2 instance = new ConnectionFactory2();

	public static ConnectionFactory2 getInstance() {
		return instance;
	}

	private ConnectionFactory2() {
		Properties prop = new Properties();

		InputStream reader = getClass().getClassLoader().getResourceAsStream("config/db.properties");

		try {
			prop.load(reader);

			driver = prop.getProperty("driver");
			url = prop.getProperty("url");
			id = prop.getProperty("id");
			password = prop.getProperty("password");
			maxConn = Integer.parseInt(prop.getProperty("maxConn"));

			// 드라이버 로딩
			Class.forName(driver);
			System.out.println("드라이버 로딩 성공");

		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public int getmaxConn() {
		return maxConn;
	}

	// DB와의 Connection 객체를 생성해서 리턴하는 메소드
	public Connection getConnection() throws SQLException {
		Connection conn = DriverManager.getConnection(url, id, password);
		return conn;
	}

}