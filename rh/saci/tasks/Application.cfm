<!---
	Este header es para que el Apache2 con mod_proxy (en lugar de jrun_mod)
	no de errores como

	[Fri Jul 16 11:27:00 2004] [error] [client 127.0.0.1] internal error: bad expires code: proxy:http://localhost:8080/cfmx/sif/tasks/Correo.cfm


	-- danim, 16-jul-04
---><cfheader name="Expires" value="0">