<cfparam name="attributes.conControl" 		default="false">
<cfparam name="attributes.conLiquidacion" 	default="false">
<cfparam name="attributes.OBPid" 			default="">
<cfset LvarReadonly = (attributes.OBPid NEQ "")>

<cfparam name="session.obras.OBTPid" 	default="-1">
<cfparam name="session.obras.OBPid" 	default="-1">

<cfif isdefined("form.cboOBTPid") AND form.cboOBTPid NEQ session.obras.OBTPid>
	<cfset session.obras.OBTPid = form.cboOBTPid>
	<cfset session.obras.OBPid = -1>
	<cfset form.OBPid = "">
	<cfset form.OBOid = "">
	<cfset form.OBEid = "">
<cfelseif isdefined("form.cboOBPid")>
	<cfif form.cboOBPid NEQ "">
		<cfset session.obras.OBPid = form.cboOBPid>
	<cfelse>
		<cfset session.obras.OBPid = -1>
	</cfif>
	<cfset form.OBOid = "">
	<cfset form.OBEid = "">
</cfif>

<cfif attributes.OBPid NEQ "">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select OBTPid, OBPid
		  from OBproyecto
		 where Ecodigo 	= #session.Ecodigo#
		   and OBPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.OBPid#">
	</cfquery>
	<cfif rsSQL.OBPid NEQ "">
		<cfset session.obras.OBTPid	= rsSQL.OBTPid>
		<cfset session.obras.OBPid	= rsSQL.OBPid>
	<cfelse>
		<cfset session.obras.OBTPid	= -1>
		<cfset session.obras.OBPid	= -1>
	</cfif>
<cfelse>
	<cfif session.obras.OBTPid NEQ "-1" AND Attributes.conControl>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select tp.OBTPid
			  from OBtipoProyecto tp
				inner join OBctasMayor cm
					 on cm.Ecodigo	= tp.Ecodigo
					and cm.Cmayor	= tp.Cmayor
					and cm.OBCcontrolCuentas = 1
			 where tp.Ecodigo	= #session.Ecodigo#
			   and tp.OBTPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBTPid#">
			 order by OBTPcodigo
		</cfquery>
		<cfif rsSQL.OBTPid EQ "">
			<cfset session.obras.OBTPid	= -1>
			<cfset session.obras.OBPid	= -1>
		</cfif>
	</cfif>
	<cfif session.obras.OBTPid EQ "-1">
		<cfset session.obras.OBPid = -1>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select tp.OBTPid
			  from OBtipoProyecto tp
			<cfif Attributes.conControl>
				inner join OBctasMayor cm
					 on cm.Ecodigo	= tp.Ecodigo
					and cm.Cmayor	= tp.Cmayor
					and cm.OBCcontrolCuentas = 1
			</cfif>
			 where tp.Ecodigo = #session.Ecodigo#
			 order by OBTPcodigo
		</cfquery>
		<cfif rsSQL.OBTPid NEQ "">
			<cfset session.obras.OBTPid = rsSQL.OBTPid>
		</cfif>
	</cfif>
	<cfif session.obras.OBPid EQ "-1">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select p.OBPid
			  from OBproyecto p
			<cfif Attributes.conControl>
				inner join OBtipoProyecto tp
					 on tp.Ecodigo	= tp.Ecodigo
					and tp.OBTPid	= tp.OBTPid
				inner join OBctasMayor cm
					 on cm.Ecodigo	= tp.Ecodigo
					and cm.Cmayor	= tp.Cmayor
					and cm.OBCcontrolCuentas = 1
			</cfif>
			 where p.Ecodigo 	= #session.Ecodigo#
			   and p.OBTPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBTPid#">
			 order by p.OBPcodigo
		</cfquery>
		<cfif rsSQL.OBPid NEQ "">
			<cfset session.obras.OBPid = rsSQL.OBPid>
		</cfif>
	</cfif>
</cfif>
<cfset form.OBTPid = session.obras.OBTPid>
<cfset form.OBPid = session.obras.OBPid>

<cfset LvarFiltro = "1=1">
<cfif session.obras.OBPid NEQ "-1">
	<cfset LvarFiltro = "OBPid = #session.obras.OBPid#">
</cfif>
<cfparam name="request.CboOBP_index" default="0">
<cfset request.CboOBP_index = request.CboOBP_index + 1>
<cfif request.CboOBP_index EQ 1>
	<cfset LvarCboOBP_index = "">
<cfelse>
	<cfset LvarCboOBP_index = request.CboOBP_index>
</cfif>
<form name="formCboOBP<cfoutput>#LvarCboOBP_index#</cfoutput>" method="post" style="text-align:left;">
	<table>
		<tr>
			<td>
				<strong>Tipo:</strong>
			</td>
			<td>
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select OBTPid, OBTPcodigo, OBTPdescripcion
					  from OBtipoProyecto tp
					<cfif Attributes.conControl>
						inner join OBctasMayor cm
							 on cm.Ecodigo	= tp.Ecodigo
							and cm.Cmayor	= tp.Cmayor
							and cm.OBCcontrolCuentas = 1
					</cfif>
					 where tp.Ecodigo = #session.Ecodigo#
					<cfif LvarReadonly>
					   and OBTPid = #session.obras.OBTPid#
					</cfif>
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<cfoutput>
						No existen Tipos de Obra con Control de Cuentas.<BR><strong>¡No es necesario administrar las Cuentas Financieras de las Etapas de Obras abiertas!</strong>
						<cfabort>
					</cfoutput>
				</cfif>
				<cfoutput>
				<cfset LvarTitulo = "Lista de Proyectos">
				<cfif LvarReadonly>
					<input type="text"
						value="#rsSQL.OBTPcodigo#" size="10" 
						autocomplete="off"
					
						tabindex="-1"
						readonly
						style="border:solid 1px ##CCCCCC; background:inherit;"
					><input type="text"
						value="#rsSQL.OBTPdescripcion#" size="40" 
						autocomplete="off"
					
						tabindex="-1"
						readonly
						style="border:solid 1px ##CCCCCC; background:inherit;"
					>
						<cfset LvarTitulo = "Lista de Proyectos Tipo '#trim(rsSQL.OBTPcodigo)# - #rsSQL.OBTPdescripcion#'">
				<cfelse>
					<select	name="cboOBTPid" id="cboOBTPid" 
							onchange="sbCboOBP_Recargar#LvarCboOBP_index#();"
					>
					<cfloop query="rsSQL">
						<option value="#rsSQL.OBTPid#" <cfif rsSQL.OBTPid EQ session.obras.OBTPid>
							selected
							<cfset LvarTitulo = "Lista de Proyectos Tipo '#trim(rsSQL.OBTPcodigo)# - #rsSQL.OBTPdescripcion#'">
							</cfif>
						>#rsSQL.OBTPcodigo# - #rsSQL.OBTPdescripcion#</option>
					</cfloop>
					</select>
				</cfif>
				</cfoutput>
			</td>
		<tr>
			<td>
				<strong>Proyecto:</strong>
			</td>
			<td>
				<cf_conlis
					title			= "#LvarTitulo#"
					readOnly		= "#LvarReadonly#"
					form			= "formCboOBP#LvarCboOBP_index#"
					campos			= "cboOBPid=OBPid, OBPcodigo, OBPdescripcion"
					desplegables	= "N,S,S"
					modificables	= "N,S,N"
					size			= "0,10,40"
				
					asignar			="cboOBPid=OBPid, OBPcodigo, OBPdescripcion"
					asignarFormatos	="S,S,S"
					funcion			= "sbCboOBP_Recargar#LvarCboOBP_index#"
			
					traerInicial	= "#session.obras.OBPid NEQ -1#"  
					traerFiltro		= "#LvarFiltro#"
				
					funcionValorEnBlanco = "sbCboOBP_EnBlanco#LvarCboOBP_index#"
					tabla			= "OBproyecto p"
					columnas		= "p.OBPid, p.OBPcodigo, p.OBPdescripcion"
					filtro			= "p.OBTPid = #session.Obras.OBTPid# order by p.OBPcodigo"
					desplegar		= "OBPcodigo, OBPdescripcion"
					etiquetas		= "Codigo, Descripcion"
					formatos		= ""
					align			= ""
					maxRowsQuery	= "200"
				/>
			</td>
		</tr>
	</table>
</form>
<script language="javascript">
	var GvarCboOPBid<cfoutput>#LvarCboOBP_index#</cfoutput>_TraerInicial = <cfif session.obras.OBPid NEQ -1>true<cfelse>false</cfif>;
	function sbCboOBP_Recargar<cfoutput>#LvarCboOBP_index#</cfoutput>()
	{
		if (GvarCboOPBid<cfoutput>#LvarCboOBP_index#</cfoutput>_TraerInicial)
		{
			GvarCboOPBid<cfoutput>#LvarCboOBP_index#</cfoutput>_TraerInicial = false;
			return;
		}
		
		document.formCboOBP<cfoutput>#LvarCboOBP_index#</cfoutput>.submit();
	}		 
	function sbCboOBP_EnBlanco<cfoutput>#LvarCboOBP_index#</cfoutput>()
	{
		GvarCboOPBid<cfoutput>#LvarCboOBP_index#</cfoutput>_TraerInicial = false;
	}
</script>
