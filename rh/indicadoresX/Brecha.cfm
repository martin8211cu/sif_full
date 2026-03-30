<html>
<title>Composici&oacute;n de la Brecha</title>
<script src="/cfmx/Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<body style="margin:0">
<cfprocessingdirective suppresswhitespace="yes">
	<cfset Empresa = Session.Ecodigo>
	<cfif isdefined('url.Puesto') and len(trim(url.Puesto))>
		<cfset Puesto = url.Puesto>
	<cfelse>
		<cfexit>
	</cfif>
	<cfif isdefined('url.Empleado') and len(trim(url.Empleado))>
		<cfset Empleado = url.Empleado>
	<cfelse>
		<cfexit>
	</cfif>

	<cfset Empresa = Session.Ecodigo>
	<cfquery name="rs" datasource="#Session.DSN#" maxrows="8">
		select 
			b.RHHcodigo as Codigo, 
			b.RHHdescripcion as Descripcion, 
			coalesce(c.RHHpeso,0) - (coalesce(c.RHHpeso,0) *a.RHCEdominio/100) as Falta, 
			100 - a.RHCEdominio as Brecha, 
			coalesce(c.RHHpeso,0) as Peso,  
			c.RHHpeso - (c.RHHpeso - (c.RHHpeso * a.RHCEdominio / 100)) as Posee,
			a.RHCEdominio as Cumplimiento,
			a.DEid as DEid,
			lt.RHPcodigo as Puesto,
			<cf_dbfunction name="concat" args="de.DEnombre,' ',de.DEapellido1,'  ',de.DEapellido2"> as NombreE,
			p.RHPdescpuesto as NombreP
		from RHCompetenciasEmpleado a
		inner join DatosEmpleado de 
			on de.DEid = a.DEid
		inner join LineaTiempo lt
		  on lt.DEid = a.DEid
		  and getdate() between lt.LTdesde and lt.LThasta
		  and a.Ecodigo = lt.Ecodigo
		inner join RHPuestos p
			on lt.RHPcodigo = p.RHPcodigo
			and p.Ecodigo = lt.Ecodigo
		inner join RHHabilidades b
		on a.Ecodigo=b.Ecodigo
		and a.idcompetencia=b.RHHid
		left outer join RHHabilidadesPuesto c
		  on a.Ecodigo = c.Ecodigo
		  and b.RHHid = c.RHHid
		  and c.RHPcodigo = '#Puesto#'
		where a.DEid = #Empleado#
		and b.Ecodigo = #Empresa#
		and a.tipo='H'
		and getdate() between a.RHCEfdesde and a.RHCEfhasta
		and coalesce(c.RHHpeso,0) - (coalesce(c.RHHpeso,0) *a.RHCEdominio/100) > 0
		order by c.RHHpeso desc
	</cfquery>
	<cfset LvarXML = "">
	<cfsavecontent variable="LvarXML">
		<data>
			<cfoutput>
			<variable name="#xmlformat('BrechaCapacitacion')#">
			<row>
				<column>#xmlformat('Codigo')#</column>
				<column>#xmlformat('Decripcion')#</column>
				<column>#xmlformat('Falta')#</column>
				<column>#xmlformat('Brecha')#</column>
				<column>#xmlformat('Peso')#</column>
				<column>#xmlformat('Posee')#</column>
				<column>#xmlformat('Cumplimiento')#</column>
				<column>#xmlformat('DEid')#</column>
				<column>#xmlformat('Puesto')#</column>
				<column>#xmlformat('NombreE')#</column>
				<column>#xmlformat('NombreP')#</column>
			</row>
			</cfoutput>
			<cfoutput query="rs">
				<row>
					<column>#xmlformat(rs.Codigo)#</column>
					<column>#xmlformat(rs.Descripcion)#</column>
					<column>#xmlformat(rs.Falta)#</column>
					<column>#xmlformat(rs.Brecha)#</column>
					<column>#xmlformat(rs.Peso)#</column>
					<column>#xmlformat(rs.Posee)#</column>
					<column>#xmlformat(rs.Cumplimiento)#</column>
					<column>#xmlformat(rs.DEid)#</column>
					<column>#xmlformat(rs.Puesto)#</column>
					<column>#xmlformat(rs.NombreE)#</column>
					<column>#xmlformat(rs.NombreP)#</column>
				</row>
			</cfoutput>
		</variable>
		 <cfoutput>
			<variable name="#xmlformat('Puesto')#">
			<row>
				<column>#xmlformat(Puesto)#</column>
			</row>
			</variable>
			<variable name="#xmlformat('Empleado')#">
			<row>
				<column>#xmlformat(Empleado)#</column>
			</row>
			</variable>
		   </cfoutput>
	  </data>
	</cfsavecontent>
	
	<br>
	<div align="center">
	<input type="button" onClick="funcBrecha()" value="Actualizar Datos">
	</div>

	<script>
		function funcBrecha(){//v1,v2,v3	
			var params = ''
			var width = 1030;
			var height = 550;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			params = '?Empleado='+'#Empleado#'+'&Puesto='+'#Puesto#';
			var nuevo = window.open('/cfmx/rh/indicadoresX/Brecha.cfm'+params,'GraficoBrecha','menubar=yes,resizable=yes,scrollbar=yes,top='+top+',left='+left+',height='+height+',width='+width);
			</cfoutput>
		}
	</script>
</cfprocessingdirective>

<!--- 
	El nombre del archivo XML debe ser unico, formado con la combinación de llaves que hacen a la información única,
	para que todos los usuarios que ven el archivo con la misma combinación de llaves vean la misma informacion
	En este caso la combinación es el IdEmpleado con el IdPuesto
--->
	<cf_viewFlash 
		movie = "Brecha" 
		XMLfilename = "Brecha#Empleado#_#Puesto#" 
		XMLvalue = "#LvarXML#"
	>

</body>
</html>
