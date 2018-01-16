package sql.executor.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sql.executor.domain.AvailableConnection;

public class IndexServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public IndexServlet() {
		super();
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<AvailableConnection> connections = new ArrayList<AvailableConnection>();

		ResourceBundle dbConf = ResourceBundle.getBundle("database");

		int totalConnections = 0, cont = 0;
		
		while (true) {
			try {
				dbConf.getString("db[" + (++cont) + "].driver");
				totalConnections++;
			} catch(Exception ex) {
				break;
			}
		}

		for (int i = 0; i < totalConnections; i++) {
			String name = dbConf.getString("db[" + (i+1) + "].name");
			AvailableConnection ac = new AvailableConnection((i+1), name);
			connections.add(ac);
		}
		
		request.setAttribute("connections", connections);
		request.getRequestDispatcher("query.jsp").forward(request, response);
	}
}