<form name="form1" method="post" action="agrupador_sql.cfm"  style="margin: '0' ">
	
	<!---<cfquery name="rsParam" datasource="#session.dsn#">
		select * from Parametros where Pcodigo=
	</cfquery>
	<cfquery name="inParam" datasource="#session.dsn#">	
		insert into Parametros (Ecodigo,Pcodigo,Mcodigo,Pdescripcion,Pvalor)
	</cfquery>--->

	<cfquery name="configura" datasource="#session.dsn#">
		select CxCGid, CxCGdescrip 
		from CxCGeneracion 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="lista">
		select 
			a.EAid,
			a.EAdescrip,
			a.EAfechaVen,
			a.EAestado,
			a.CxCGid,
			(select CxCGdescrip from CxCGeneracion where CxCGid = a.CxCGid) as confi
			from 
			EAgrupador a
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('form.fecha_ven') and len(trim(form.fecha_ven))>
			and a.EAfechaVen = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fecha_ven)#">
		</cfif>
	
		<cfif isdefined('form.estado') and len(trim(form.estado)) and form.estado neq -1>
			and a.EAestado= '#form.estado#'
		</cfif>	
		
		<cfif isdefined('form.config') and len(trim(form.config)) gt 0 and form.config neq -1>
			and a.CxCGid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.config#">
		</cfif>	
		 order by EAestado desc
	</cfquery>


	<!---Fecha de Vencimiento--->
	<table width="100%" border="0">
		<tr>
			<td nowrap="nowrap" align="left">
				<table>
					<tr>
						<td>
							<strong>Fecha Vencimiento:</strong>
						</td>
						<td>
							<cf_sifcalendario form="form1"  name="fecha_ven" tabindex="1">
						</td>
						</tr>
				</table>
			</td>	

			
		<!---Configuracion--->
		<td width="50%">
			<strong>Tipo Configuraci&oacute;n:</strong>
			<select name="config">  
			<option value="-1">Todos</option>
			<cfif configura.RecordCount>
				<cfoutput query="configura">
					<option value="#configura.CxCGid#">#configura.CxCGdescrip#</option>
				</cfoutput>
			</cfif>
			</select>
		</td>
	</tr>
	<!---Estado--->				
		<tr>
			<td nowrap align="left"><strong>Estado:</strong>
					<select name="estado"> 
					<option value="-1">Todos</option>		
					<option value="En Proceso">En Proceso</option>
					<option value="Aplicado">Aplicada</option>
					</select>				
				</td>		
	<!---FILTRAR--->		
			<td align="right">
			<div align="right">
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="document.form1.action='agrupador.cfm'"/>	
			</div>
			</td>
		</tr>	




</table>
</br>
<table width="100%">
<tr><td>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#lista#"
	columnas="EAid,EAdescrip,EAfechaVen,EAestado,confi"
	desplegar="EAdescrip,EAfechaVen,EAestado,confi"
	etiquetas="Descripci&oacute;n, Fecha </br> Vencimiento, Estado, Tipo </br> Configuraci&oacute;n"
	formatos="S,D,S,S"
	align="left,left,left,left"
	ira="agrupador.cfm" 
	showEmptyListMsg="yes"
	keys="EAid"	
	MaxRows="15"
	showLink="yes"
	incluyeForm="no"
	formName="form1"
	form_method="post"	
	PageIndex="1"
	checkboxes="S"
	/>	
</td></tr>
	
	<tr>
		<td align="center">  
				<input name="Nuevo" type="submit" value="Nuevo" tabindex="2">
				<input name="BorrarLista" type="submit" value="Borrar" tabindex="2"  onclick="document.form1.action='agrupador_sql.cfm'">
				<input name="AplicarLista" type="submit" value="Aplicar" tabindex="2" onclick="document.form1.action='agrupador_sql.cfm'"> 
		</td>
	</tr>    
</table>
</form>



