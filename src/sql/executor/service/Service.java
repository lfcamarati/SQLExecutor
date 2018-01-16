package sql.executor.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

public class Service {
	public static int MAX = 1000;
	
	private String[] columns;
	private Integer updateCount;
	private List<String[]> data;
	private Boolean isMax = false;
	private Long endTime = null;
	
	public void execute(String sql, String connIndex) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			if(sql == null || sql.isEmpty()) {
				throw new Exception("Query não informada!");
			}
			
			ResourceBundle dbConf = ResourceBundle.getBundle("database");
			String driver = dbConf.getString("db["+ connIndex +"].driver");
			String url = dbConf.getString("db["+ connIndex +"].url");
			String user = dbConf.getString("db["+ connIndex +"].user");
			String pass = dbConf.getString("db["+ connIndex +"].pass");
			
			Class.forName(driver);
			conn = DriverManager.getConnection(url, user, pass);
			stmt = conn.createStatement();
			stmt.setMaxRows(1000);
			
			Long startTime = System.currentTimeMillis();
			boolean isResultSet = stmt.execute(sql);
			endTime = System.currentTimeMillis() - startTime;
			
			if(isResultSet) {
				rs = stmt.getResultSet();
				
				ResultSetMetaData metaData = rs.getMetaData();
				Integer totalColumns = metaData.getColumnCount();
				
				columns = new String[totalColumns];
				for(int i = 0 ;i < totalColumns; i++) {
					columns[i] = metaData.getColumnName((i+1));
				}
				
				data = new ArrayList<String[]>();
				while(rs.next() && data.size() < MAX) {
					String[] row = new String[totalColumns];
					
					for(int i = 0 ;i < totalColumns; i++) {
						row[i] = rs.getString(columns[i]);
					}
					
					data.add(row);
				}
				
				isMax = (data.size() == MAX);
			} else {
				updateCount = stmt.getUpdateCount();
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if(rs != null)
				rs.close();
			if(stmt != null)
				stmt.close();
			if(conn != null)
				conn.close();
		}
	}

	public String[] getColumns() {
		return columns;
	}
	
	public List<String[]> getData() {
		return data;
	}

	public Boolean getIsMax() {
		return isMax;
	}

	public Long getEndTime() {
		return endTime;
	}

	public Integer getUpdateCount() {
		return updateCount;
	}
}