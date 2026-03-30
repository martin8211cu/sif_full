<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Avance Generación del reporte</title>
</head>
<body onLoad="setTimeout('window.location.reload()',2*1000);">
	<cfoutput>
		<script language="javascript">
            window.parent.document.getElementById("hora").value = "#now()#";
        </script>			
        <cfif session.Reporte.QPIncobrable EQ 2>
            <script language="javascript">
                alert("El reporte se Generó con éxito");
                parent.location.href="QPassRIncobrables.cfm";
            </script>
        </cfif>
    </cfoutput>
</body>
</html>
