<cf_templateheader title="Modelos de Base de Datos">
<cf_web_portlet_start titulo="Modelos de Base de Datos">
<cf_templatecss>
	<cfquery name="rsMODs" datasource="asp">
		select s.IDsch, s.sch, m.IDmod, m.modelo,
				(
					select max(IDver)
					  from DBMversiones v
					 where IDmod = m.IDmod
				) as verUlt,
				(
					select max(fec)
					  from DBMversiones v
					 where IDmod = m.IDmod
				) as fecha
		  from DBMmodelos m
		  	inner join DBMsch s
				on s.IDsch = m.IDsch
		 order by s.IDsch
	</cfquery>
	<cfquery name="rsSCHs" datasource="asp">
		select s.IDsch, s.sch
		  from DBMsch s
		 order by s.IDsch
	</cfquery>
	<table>
		<tr>
			<td colspan="5" style="border-bottom:solid 1px ##CCCCCC; height:1px; font-size:1px;">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td><strong>OP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></td>
			<td><strong>MODELO</strong></td>
			<td align="center"><strong>ULT<BR>VER</strong></td>
			<td><strong>FECHA</strong></td>
		</tr>
	<cfoutput query="rsMODs" group="IDsch">
		<tr>
			<td colspan="5" style="border-bottom:solid 1px ##CCCCCC; height:1px; font-size:1px;">&nbsp;
				
			</td>
		</tr>
		<tr>
			<td></td>
			<td colspan="2"><strong>SCHEMA: #sch#</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
	<cfoutput>
		<tr>
			<td>
				<cfif verUlt NEQ "">
				<img src="/cfmx/asp/parches/images/genScriptDL.gif" 	style="cursor:pointer" onclick="return sbOP(1,#IDmod#);" alt="Script BASE CERO de '#modelo#'">
				<img src="/cfmx/asp/parches/images/genXMLDL.gif" 	style="cursor:pointer" onclick="return sbOP(2,#IDmod#);" alt="XML de actualización de '#modelo#'">
				<cfelse>
				<img src="/cfmx/asp/parches/images/deletesmall.gif" 	style="cursor:pointer" onclick="return sbOP(3,#IDmod#);" alt="Eliminar '#modelo#'">
				</cfif>
			</td>
			<td>#modelo#</td>
			<td align="center">&nbsp;#verUlt#&nbsp;</td>
			<td>#fecha#</td>
		</tr>
	</cfoutput>
	</cfoutput>
		<tr>
			<td colspan="5" style="border-bottom:solid 1px ##CCCCCC; height:1px; font-size:1px;">&nbsp;
				
			</td>
		</tr>
	</table>

<BR />
<strong>CREAR NUEVO MODELO POWERDESIGNER:</strong><BR>
	<table>
		<tr>
			<td><strong>Schema:</strong></td>
			<td>
				<select name="IDsch">
					<cfoutput query="rsSCHs">
					<option value="#IDsch#">#sch#</option>
					</cfoutput>	
				</select>
			</td>
		</tr>
		<tr>
			<td><strong>Modelo:</strong></td>
			<td>
				<input type="file" style="width:600px" onChange="document.getElementById('modelo').value = fnFile(this.value);" />
				<input type="hidden" name="modelo" id="modelo"/>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input type="button" value="Crear" onClick="fnCrear();" />
			</td>
		</tr>
	</table>
	<script language="javascript">
		function fnFile(archivo)
		{
			var file = archivo.replace("/","\\");
			file = file.split("\\");
			return 	(file[file.length-1]);
		}

		function fnCrear()
		{
			var file = document.getElementById('modelo').value;
			var pto = file.find(".");
			if (pto > 0)
			{
				if (file.substring(file.length, file.length - 4) != ".pdm")
					pto = 0;
			}
			if (pto == 0)
			{
				alert("Archivo no corresponde a un modelo PowerDesigner .pdm")
				return false;
			}
			location.href = "DBMmodelos_sql.cfm?OP=4&IDsch=" + document.getElementById('IDsch').value + "&modelo=" + escape(file);
		}

		var dis = false;
		function sbOP (op, ID)
		{
			if (dis) 
			{
				return false;
			}
			if (op == 1)
			{
				document.getElementById('ifrOP').src = "DBMmodelos_sql.cfm?OP=1&IDmod=" + ID;
			}
			else if (op == 2)
			{
				document.getElementById('ifrOP').src = "DBMmodelos_sql.cfm?OP=2&IDmod=" + ID;
			}
			else if (op == 3)
			{
				dis = true;
				location.href = "DBMmodelos_sql.cfm?OP=3&IDmod=" + ID;
			}
		}
	</script>
	<iframe id="ifrOP" frameborder="0" height="0"></iframe>
<BR>
<cf_web_portlet_end>
<cf_templatefooter>