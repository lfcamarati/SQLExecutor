package sql.executor.controller;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import sql.executor.domain.DbMetaData;

import json.java.annotation.AjaxController;

@AjaxController(name = "loadSchema")
public class LoadSchemaController {
	
	public static final Map<String, List<DbMetaData>> SCHEMAS = new HashMap<String, List<DbMetaData>>();
	
	public List<DbMetaData> loadSchema(String connIndex) throws Exception {
		if(SCHEMAS.containsKey(connIndex)) {
			return SCHEMAS.get(connIndex);
		}
		
		Connection conn = null;
		ResultSet result = null;

		try {
			ResourceBundle dbConf = ResourceBundle.getBundle("database");
			String driver = dbConf.getString("db[" + connIndex + "].driver");
			String url = dbConf.getString("db[" + connIndex + "].url");
			String schema = dbConf.getString("db[" + connIndex + "].schema");
			String user = dbConf.getString("db[" + connIndex + "].user");
			String pass = dbConf.getString("db[" + connIndex + "].pass");

			Class.forName(driver);
			conn = DriverManager.getConnection(url, user, pass);
			DatabaseMetaData metaData = conn.getMetaData();

			String tableType[] = { "TABLE" };
			
			result = metaData.getTables(null, schema, null, tableType);
			
			List<DbMetaData> metaDados = new ArrayList<DbMetaData>();
			
			while (result.next()) {
				DbMetaData item = new DbMetaData();
				
				item.setTableName(result.getString(3));
				
				ResultSet columns = metaData.getColumns(null, null, item.getTableName(), null);
				
				while (columns.next()) {
					String columnName = columns.getString(4);
					item.getColumns().add(columnName);
				}
				
				metaDados.add(item);
			}
			
			if(!SCHEMAS.containsKey(connIndex)) {
				SCHEMAS.put(connIndex, metaDados);
			}
			
			return metaDados;
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if(result != null)
				result.close();
			if(conn != null)
				conn.close();
		}
	}
	
}