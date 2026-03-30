<cfset varfiltro = '1=1'>
<cfif isNull(#LB_Titulo#)>
<cf_dbfunction name="op_concat" returnvariable="concat">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo	= t.Translate('LB_Titulo',		'Gestion de Reportess', 			'GestionReportes.xml')>
<cfset LB_TituloVE	= t.Translate('LB_TituloVE',	'Consultar/Editar Reporte', 		'GestionReportes.xml')>
<cfset LB_TituloN	= t.Translate('LB_TituloN',		'Nuevo Reporte',			 		'GestionReportes.xml')>
<cfset LB_TituloCol	= t.Translate('LB_TituloCol',	'Columnas', 						'GestionReportes.xml')>
<cfset LB_Codigo	= t.Translate('LB_Codigo',		'Código', 							'GestionReportes.xml')>
<cfset LB_Desc		= t.Translate('LB_Desc',		'Descripción', 						'GestionReportes.xml')>
<cfset LB_Modulo	= t.Translate('LB_Modulo',		'Módulo', 						'GestionReportes.xml')>
<cfset LB_Exclusivo	= t.Translate('LB_Exclusivo',	'Exclusivo', 						'GestionReportes.xml')>
<cfset LB_Si		= t.Translate('LB_Si',			'Si', 								'GestionReportes.xml')>
<cfset LB_No		= t.Translate('LB_No',			'No', 								'GestionReportes.xml')>
<cfset LB_Selec		= t.Translate('LB_Selec',		'-- Seleccionar --', 				'GestionReportes.xml')>
<cfset LB_Ninguno	= t.Translate('LB_Ninguno',		'Ninguno', 							'GestionReportes.xml')>
<cfset LB_Relaciones= t.Translate('LB_Relaciones',	'Relaciones', 						'GestionReportes.xml')>
<cfset LB_Variables	= t.Translate('LB_Variables',	'Variables', 						'GestionReportes.xml')>
<cfset LB_Consulta	= t.Translate('LB_Consulta',	'Consulta', 						'GestionReportes.xml')>
<cfset LB_Guardar	= t.Translate('LB_Guardar',		'Guardar', 							'GestionReportes.xml')>
<cfset LB_Nuevo		= t.Translate('LB_Nuevo',		'Nuevo', 							'GestionReportes.xml')>
<cfset LB_Eliminar	= t.Translate('LB_Eliminar',	'Eliminar Reporte', 				'GestionReportes.xml')>
<cfset LB_OriDat	= t.Translate('LB_OriDat',		'Origenes de Datos', 				'GestionReportes.xml')>
<cfset LB_Columnas	= t.Translate('LB_Columnas',	'Columnas', 						'GestionReportes.xml')>
<cfset MSG_Eliminar	= t.Translate('MSG_Eliminar','Se eliminará el reporte y todas sus versiones asociadas. Deseas Eliminar?', 		'GestionReportes.xml')>
<cfset MSG_Falla	= t.Translate('MSG_Falla','Ocurrió una Falla, verificar el Query', 	'GestionReportes.xml')>
</cfif>


<cf_templateheader titulo="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfoutput>
			<form action="listaGestionReportes.cfm" method="post" name="filtroBal">
				<div style="background-color:rgb(232,232,232); width:100%">
					<br>
					<!--- TABLA DEL FILTRO --->
					<table  width="95%" align="center" cellpadding="0" cellspacing="2" border="0">
						<tr>
							<!--- CODIGO --->
						    <td nowrap align="right"><strong>#LB_Codigo#:</strong>&nbsp;</td>
						    <td>
							    <input type="text" id="RPCodigo" name="RPCodigo" value="<cfif isdefined('form.RPCodigo')>#form.RPCodigo#</cfif>">
							</td>
							<!--- DESCRIPCIÓN --->
							<td nowrap align="right"><strong>#LB_Desc#:</strong>&nbsp;</td>
							<td>
								<input type="text" id="RPDescripcion" name="RPDescripcion" value="<cfif isdefined('form.RPDescripcion')>#form.RPDescripcion#</cfif>">
							</td>
							<!--- EXCLUSIVO --->
							<td nowrap align="right"><strong>#LB_Exclusivo#:</strong>&nbsp;</td>
							<td>
								<select name="GRExc" id="GRexc">
									<option value="-1">#LB_Selec#</option>
									<option value="1" <cfif isdefined("form.GRexc") && form.GRexc EQ 1>selected</cfif>>#LB_Si#</option>
									<option value="0" <cfif isdefined("form.GRexc") && form.GRexc EQ 0>selected</cfif>>#LB_No#</option>
								</select>
							</td>
							<!--- BOTÓN FILTRO --->
							<td align="right">
								<input type="submit" value="filtrar" id="friltrar" name="friltrar" class="btnFiltrar">
							</td>
						</tr>
					</table>
				</div>
				<!--- MANEJO DEL FILTRO --->
				<cfset varfiltro = "SScodigo = '#Session.menues.SScodigo#'">
				<cfif isdefined("form.RPCodigo") and form.RPCodigo NEQ ''>
					<cfset varfiltro = "#varfiltro# and RPCodigo like '#form.RPCodigo#%'">
				</cfif>
				<cfif isdefined("form.RPDescripcion") and form.RPDescripcion GT 0>
					<cfset varfiltro = "#varfiltro# and UPPER(RPDescripcion) like UPPER('%#form.RPDescripcion#%')">
				</cfif>
				<cfif isDefined("form.GRexc") and form.GRexc EQ 1>
					<cfset varfiltro = varfiltro & "and Ecodigo = #Session.Ecodigo#">
				<cfelse>
					<cfset varfiltro = varfiltro & "and (Ecodigo = #Session.Ecodigo#  or Ecodigo is null)">
				</cfif>

				<!--- LISTA --->
				<cf_dbfunction name="to_char" args="RPTId" returnvariable="toCharRPTId">
				<cf_dbfunction name="op_concat" returnvariable="concat">
				<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla	   		= "RT_Reporte"
						columnas  		= "RPTId, RPCodigo, RPDescripcion,
											case
												when COALESCE(Ecodigo,0) > 0 then '<i class=''fa fa-check-square-o fa-lg''></i>'
												else '<i class=''fa fa-square-o fa-lg''></i>'
											end Exclusivo,
											case
												when COALESCE(RPPublico,0) > 0 then '<i class='' fa fa-check-square-o fa-lg''></i>'
												else '<i class=''fa fa-square-o fa-lg''></i>'
											end Publico,
											'<i class=''fa fa-user fa-lg'' style=''cursor:pointer;'' onclick=''PermisoUsuario(' #concat# #toCharRPTId# #concat# ');''></i>&nbsp;
											<i class=''fa fa-users fa-lg'' style=''cursor:pointer;'' onclick=''PermisoRoles(' #concat# #toCharRPTId# #concat# ');''></i>&nbsp;
											<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''fnOper(' #concat# #toCharRPTId# #concat# ',3);''></i>&nbsp;
											<i class=''  style=''cursor:pointer;'' onclick=''fnOper(' #concat# #toCharRPTId# #concat# ',5);''></i>&nbsp;
											<i class=''fa fa-trash-o fa-lg'' style=''cursor:pointer;'' onclick=''fnOper(' #concat# #toCharRPTId# #concat# ',4);''></i>' as acciones"
						desplegar			= "RPCodigo, RPDescripcion, Exclusivo, Publico, Acciones"
						etiquetas			= "#LB_Codigo#,#LB_Desc#,Exclusivo&nbsp;,&nbsp;Público&nbsp;,&nbsp;"
						formatos			= "S,S,S,S,S"
						align 				= "left,left,center,center,center"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "true"
						filtro				= "#varfiltro#"
						formname			= "filtro"
						navegacion			= ""
						mostrar_filtro		= "false"
						filtrar_automatico	= "false"
						showLink			= "false"
						showemptylistmsg	= "true"
						keys				= "RPTId"
						MaxRows				= "50"
						/>
						<br>
				<div class="">
					<input type="button"  onclick="fnOper(0,1);" value="Nuevo"
						class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto; ">
				</div>
			</form>
		</cfoutput>
		</div>

		<!--- DIVS MODALS --->
		<div id="dialog-confirmEli"></div>
		<div id="popupViewEdit" style="display: none;"></div>
		<div id="popupPermisosUser" style="display: none;"> <!---popUp Permisos Usuarios--->
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- JAVASCRIPT --->
<script language="javascript" type="text/javascript">
	// VARIABLES GLOBALES
	var modalRep = '#popupViewEdit';
	var titleCE	 = '<cfoutput>#LB_TituloVE#</cfoutput>';
	var titleNew = '<cfoutput>#LB_TituloN#</cfoutput>';
	// MANEJO DE OPERACIONES
	function fnOper(RPTId,option){
		var del = false;
		// 1 = new, 2 = view, 3 = edit
		switch (option){
			case 1:
				var url = "GestionReportes.cfm?modo=ALTA&RPTId=0";
				break;
			case 2:
				var url = "GestionReportes.cfm?modo=VISTA&RPTId="+RPTId;
				break;
			case 3:
				var url = "GestionReportes.cfm?modo=CAMBIO&RPTId="+RPTId;
				break;
			case 4:
				del = true;
				break;
			default:
				var url = "listaGestionReportes.cfm";
				break;
		}
		if (del){
			deleteRP(RPTId);
		}else if(option == 1){
			fnGetModal(url,modalRep, titleNew)
		}else{
			fnGetModal(url,modalRep, titleCE)
		}
	}
	// LEVANTA MODAL
	function fnGetModal(url,modal,title){
	    $.ajax({
			type: "GET",
			url: url,
			success: function(result){
		        $(modal).html(result);
		    }
		});
		$(modal).dialog({
	        width: 600,
	        modal:true,
	        title:title,
	        resizable: "false",
	        position:['middle',20]
	    });
	}
	// BORRAR REPORTE
	function deleteRP(RPTId){
		$("#dialog-confirmEli").html("<cfoutput>#MSG_Eliminar#</cfoutput>");
	    $("#dialog-confirmEli").dialog({
	        resizable: false,
	        modal: true,
	        title: "<cfoutput>#LB_Eliminar#</cfoutput>",
	        height: 120,
	        width: 250,
	        buttons: {
	            "Si": function () {
	            	var url = "GestionReportes-sql.cfm?modo=BORRAR&RPTId="+RPTId;;
					$(location).attr('href',url);
	                $(this).dialog('close');
	                // callback(true);
	            },
	            "No": function () {
	                $(this).dialog('close');
	                // callback(false);
	            }
	        }
	    });
	}

	function PermisoUsuario(RPTId){
		$.ajax({
			type: "GET",
			url: "/cfmx/commons/GeneraReportes/GestionReportes/PermisosUsuarios-form.cfm?RPTId="+RPTId+"&User=1",
			success: function(result){
		        $("#popupPermisosUser").html(result);
		    }
		});

		$("#popupPermisosUser").dialog({
	        width: 520,
	        modal:true,
	        title:"Permisos por Usuario",
	        height: 400,
	        resizable: "false",
	    });
	}

	function PermisoRoles(RPTId){
		$.ajax({
			type: "GET",
			url: "/cfmx/commons/GeneraReportes/GestionReportes/PermisosUsuarios-form.cfm?RPTId="+RPTId+"&User=2",
			success: function(result){
		        $("#popupPermisosUser").html(result);
		    }
		});

		$("#popupPermisosUser").dialog({
	        width: 520,
	        modal:true,
	        title:"Permisos por Rol",
	        height: 400,
	        resizable: "false",
	    });

	}
</script>