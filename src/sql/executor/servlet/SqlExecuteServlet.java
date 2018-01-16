package sql.executor.servlet;

import java.io.IOException;
import java.util.LinkedList;
import java.util.Queue;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sql.executor.service.Service;

public class SqlExecuteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public SqlExecuteServlet() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql = request.getParameter("sql");
		String connIndex = request.getParameter("conn");
		Service sqlService = new Service();
		
		try {
			sqlService.execute(sql, connIndex);
			
			Integer updateCount = sqlService.getUpdateCount();
			
			if(updateCount != null) {
				request.setAttribute("updateCount", updateCount);
			} else {
				request.setAttribute("executionTime", sqlService.getEndTime());
				request.setAttribute("columns", sqlService.getColumns());
				request.setAttribute("data", sqlService.getData());
				request.setAttribute("max", Service.MAX);
			}
			saveLastQuery(sql, request);
		} catch (Exception e) {
			request.setAttribute("erro", e.getMessage());
		}
		
		request.setAttribute("isMax", sqlService.getIsMax());
		request.setAttribute("sql", sql);
		request.getRequestDispatcher("sqlResult.jsp").forward(request, response);
	}
	
	@SuppressWarnings("unchecked")
	private void saveLastQuery(String query, HttpServletRequest request) {
		if(query == null || query.isEmpty()) {
			return;
		}
		
		String[] q = new String[2];
		
		if(query.length() > 100) {
			q[0] = query.substring(0, 100) + "...";
		} else {
			q[0] = query;
		}
		q[1] = query;
		
		
		HttpSession session = request.getSession();
		Queue<String[]> fiveLastQueries = (Queue<String[]>) session.getAttribute("fiveLastQueries");
		
		if(fiveLastQueries == null) {
			fiveLastQueries = new LinkedList<String[]>();
			session.setAttribute("fiveLastQueries", fiveLastQueries);
		}
		
		boolean jaExiste = false;
		for(String[] t : fiveLastQueries) {
			if(t[1].equals(q[1])) {
				jaExiste = true;
			}
		}
		
		if(jaExiste) {
			return;
		}
		
		if(fiveLastQueries.size() == 10) {
			fiveLastQueries.poll();
		}
		
		fiveLastQueries.add(q);
	}
}