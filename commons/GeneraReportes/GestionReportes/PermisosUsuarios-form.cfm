<cfif isdefined('url.User') and url.User EQ 1>

	<cfquery name="rsReporUser" datasource= "#session.DSN#">
		SELECT distinct u.Usucodigo, u.Usulogin, UPPER(b.Pnombre) + ' ' + UPPER(b.Papellido1) + ' ' + UPPER(b.Papellido2) as usuario, rp.RPTId
		FROM Usuario u
			INNER JOIN DatosPersonales b on u.datos_personales = b.datos_personales
			INNER JOIN vUsuarioProcesos a ON a.Usucodigo = u.Usucodigo
			INNER JOIN Empresas d ON d.EcodigoSDC = a.Ecodigo
			AND d.Ecodigo = #session.Ecodigo#
			INNER JOIN RT_ReportePermiso rp ON rp.Usucodigo = u.Usucodigo
		WHERE CEcodigo = #session.CEcodigo#
		AND rp.RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RPTId#">
	</cfquery>

	<cfoutput>
	<form name="formPermisos" action="PermisosUsuarios-sql.cfm" method="post">
		<input type="hidden" name="RPTId" value="#url.RPTId#">
	<div>
		<div class="row">
			<div class="col-md-2">
				<label><strong>Usuario</strong></label>
			</div>
			<div class="col-md-10">
				<input type="hidden" name="Usucodigo1" value="">
				<input type="text" name="usuario1" size="50" value="" readonly>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Usuarios" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisUsuarios(1,#url.RPTId#);'></a>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
				<input type="submit" value="AGREGAR" id="btnAgregarU" name="btnAgregarU" class="btnAgregar">
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
				<table class="table table-hover">
					<tbody>
						<tr>
							<td width="20%">
								<label><strong>Usuario</strong></label>
							</td>
							<td width="60%">
								<label><strong>Nombre</strong></label>
							</td>
							<td width="20%">
							</td>
						</tr>
						<cfloop query="rsReporUser">
						<cfset varRPTid = #rsReporUser.RPTId#>
						<cfset varUsucodigo = #rsReporUser.Usucodigo#>
						<tr>
							<td width="20%">
								#rsReporUser.Usulogin#
							</td>
							<td width="60%">
								#rsReporUser.usuario#
							</td>
							<td width="20%">
								<i class="fa fa-trash-o fa-lg" style="cursor:pointer;" onclick="deletePU(#varRPTid#,#varUsucodigo#);"></i>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<div id="dialog-confirmEli"></div><!---Div para que salga el dialogo de eliminar permisos--->
	</form>
	</cfoutput>
<cfelseif isdefined('url.User') and url.User EQ 2>
	<cfquery name="rsRoles" datasource="sifcontrol">
		SELECT UPPER(SRcodigo) as SRcodigo
		FROM RT_ReportePermiso
		WHERE SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
		AND RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RPTId#">
	</cfquery>

		<cfset listRoles = "">

		<cfloop query="rsRoles">
			<cfset listRoles = ListAppend(listRoles,"'"&rsRoles.SRcodigo&"'")>
		</cfloop>

	<cfif isdefined('rsRoles') and rsRoles.RecordCount GT 0>
		<cfquery name="rslistaRoles" datasource="asp">
			SELECT UPPER(SScodigo) as SScodigo,UPPER(SRcodigo) as SRcodigo,UPPER(SRdescripcion) as SRdescripcion
			FROM SRoles
			WHERE SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
				AND UPPER(SRcodigo) IN (#preservesinglequotes(listRoles)#)
		</cfquery>
	</cfif>

	<cfoutput>
	<form name="formPermisos" action="PermisosUsuarios-sql.cfm" method="post">
		<input type="hidden" name="RPTId" value="#url.RPTId#">
	<div>
		<div class="row">
			<div class="col-md-2">
				<label><strong>Rol</strong></label>
			</div>
			<div class="col-md-10">
				<input type="hidden" name="SScodigo1" value="">
				<input type="text" name="SRcodigo1" size="50" value="" readonly>
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Roles" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRoles(1,#url.RPTId#);'></a>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
				<input type="submit" value="AGREGAR" id="btnAgregarR" name="btnAgregarR" class="btnAgregar">
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
			</div>
		</div>
		<cfif isdefined('rslistaRoles') and rslistaRoles.RecordCount GT 0>
		<div class="row">
			<div class="col-md-12" align="center">
				<table class="table table-hover">
					<tbody>
						<tr>
							<td width="20%">
								<label><strong>Rol</strong></label>
							</td>
							<td width="60%">
								<label><strong>Descripcion</strong></label>
							</td>
							<td width="20%">
							</td>
						</tr>

						<cfloop query="rslistaRoles">
						<cfset varRPTid = #url.RPTId#>
						<cfset varSScodigo = #rslistaRoles.SScodigo#>
						<cfset varSRcodigo = #rslistaRoles.SRcodigo#>

						<tr>
							<td width="20%">
								#rslistaRoles.SRcodigo#
							</td>
							<td width="60%">
								#rslistaRoles.SRdescripcion#
							</td>
							<td width="20%">
								<i class="fa fa-trash-o fa-lg" style="cursor:pointer;" onclick="deletePR(#varRPTid#,'#varSScodigo#','#varSRcodigo#');"></i>
							</td>
						</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
		</cfif>
	</div>
	<div id="dialog-confirmEli"></div><!---Div para que salga el dialogo de eliminar permisos--->
	</form>
	</cfoutput>
</cfif>

<script language="javascript" type="text/javascript">
 	//Conlis de usuarios de anexos
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
	   		if(!popUpWin.closed) popUpWin.close();
	  		}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	 }

	function doConlisUsuarios(index,RPTId){
		popUpWindow("conlistPermisosUsuarios.cfm?formulario=formPermisos&index="+index+"&RPTId="+RPTId,160,90,1000,500);
	 }

	function doConlisRoles(index,RPTId){
		popUpWindow("conlistPermisosRoles.cfm?formulario=formPermisos&index="+index+"&RPTId="+RPTId,160,90,1000,500);
	 }

	function deletePU(RPTId,Usucodigo)
	{
	   $("#dialog-confirmEli").html("Deseas eliminar los permisos al usuario?");
	   $("#dialog-confirmEli").dialog({
	        resizable: false,
	        modal: true,
	        title: "Eliminar Permisos al Usuario",
	        height: 120,
	        width: 250,
	        buttons: {
	            "Si": function () {
	            	var url = "PermisosUsuarios-sql.cfm?btnEliminar=1&RPTId="+RPTId+"&Usucodigo="+Usucodigo;
					$(location).attr('href',url);
	                $(this).dialog('close');
	                callback(true);
	            },
	                "No": function () {
	                $(this).dialog('close');
	                callback(false);
	            }
	        }
	    });
	}

	function deletePR(RPTId,SScodigo,SRcodigo)
	{
	   $("#dialog-confirmEli").html("Deseas eliminar los permisos al rol?");
	   $("#dialog-confirmEli").dialog({
	        resizable: false,
	        modal: true,
	        title: "Eliminar Permisos Roles",
	        height: 120,
	        width: 250,
	        buttons: {
	            "Si": function () {
	            	var url = "PermisosUsuarios-sql.cfm?btnEliminarR=1&RPTId="+RPTId+"&SScodigo="+SScodigo+"&SRcodigo="+SRcodigo;
					$(location).attr('href',url);
	                $(this).dialog('close');
	                callback(true);
	            },
	                "No": function () {
	                $(this).dialog('close');
	                callback(false);
	            }
	        }
	    });
	}
</script>