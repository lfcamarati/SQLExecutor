package sql.executor.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class DbMetaData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String tableName;
	private List<String> columns;
	
	public DbMetaData() {
		super();
		columns = new ArrayList<String>();
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public List<String> getColumns() {
		return columns;
	}

	public void setColumns(List<String> columns) {
		this.columns = columns;
	}
}