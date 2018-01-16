package sql.executor.servlet;

import java.io.IOException;
import java.util.LinkedList;
import java.util.Queue;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LastQueriesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LastQueriesServlet() {
		super();
	}

	@SuppressWarnings("unchecked")
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		Queue<String[]> fiveLastQueries = (Queue<String[]>) session.getAttribute("fiveLastQueries");
		
		if(fiveLastQueries == null) {
			fiveLastQueries = new LinkedList<String[]>();
		}
		
		request.setAttribute("fiveLastQueries", fiveLastQueries);
		request.getRequestDispatcher("lastQueries.jsp").forward(request, response);
	}
}
