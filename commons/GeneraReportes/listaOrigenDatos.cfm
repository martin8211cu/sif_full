<cfset varfiltro = '1=1'>

<cf_templateheader titulo="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfoutput>
			<cfform action="OrigenDatos.cfm" method="post" name="filtroBal">
				<div style="background-color:rgb(232,232,232); width:100%">
					<br>
					<table  width="95%" align="center" cellpadding="0" cellspacing="2" border="0">
						<tr>
						    <td nowrap align="right"><strong>#LB_Codigo#:</strong>&nbsp;</td>
						    <td>
							    <input type="text" id="ODCodigo" name="ODCodigo" value="<cfif isdefined('form.ODCodigo')>#form.ODCodigo#</cfif>">
							</td>
							<td nowrap align="right"><strong>#LB_Desc#:</strong>&nbsp;</td>
							<td>
								<input type="text" id="ODDesc" name="ODDesc" value="<cfif isdefined('form.ODexc')>#form.ODDesc#</cfif>">
							</td>
							<td nowrap align="right"><strong>#LB_Exclusivo#:</strong>&nbsp;</td>
							<td>
								<select name="ODExc" id="ODexc">
									<option value="-1">#LB_Selec#</option>
									<option value="1" <cfif isdefined("form.ODDesc") && form.ODexc EQ 1>selected</cfif>>#LB_Si#</option>
									<option value="0" <cfif isdefined("form.ODDesc") && form.ODexc EQ 0>selected</cfif>>#LB_No#</option>
								</select>
							</td>
							<td align="right"><input type="submit" value="filtrar" id="friltrar" name="friltrar" class="btnFiltrar" onclick="return funcFiltrar()"></td>
						</tr>
					</table>
				</div>
				<!--- <cfset varfiltro = "(Ecodigo = #Session.Ecodigo# or Ecodigo = '' or Ecodigo is null)"> --->

				<cfif isdefined("form.ODCodigo") and form.ODCodigo NEQ ''>
					<cfset varfiltro = varfiltro & "and ODCodigo like '#form.ODCodigo#%'">
				</cfif>
				<cfif isdefined("form.ODDesc") and form.ODDesc GT 0>
					<cfset varfiltro = varfiltro & "and UPPER(ODDescripcion) like UPPER('%#form.ODDesc#%')">
				</cfif>
				<cfif isDefined("form.ODExc") and form.ODExc EQ 1>
					<cfset varfiltro = varfiltro & "and Ecodigo = #Session.Ecodigo#">
				<cfelse>
					<cfset varfiltro = varfiltro & "and (Ecodigo = #Session.Ecodigo# or Ecodigo = '' or Ecodigo is null)">
				</cfif>
				<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla	   		= "RT_OrigenDato"
						columnas  		= "ODId, ODCodigo, ODDescripcion,
										   	CASE
				   								WHEN Ecodigo is not null AND Ecodigo != 0
													THEN '<i class=''fa fa-check-square-o fa-lg''></i>'
													ELSE '<i class=''fa fa-square-o fa-lg''></i>'
											END Exclusivo,
											'<i class=''fa fa-search fa-lg'' style=''cursor:pointer;'' onclick=''formOD(' + cast(ODId as varchar) + ',2);''></i>&nbsp;
											<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''formOD(' + cast(ODId as varchar) + ',3);''></i>&nbsp;
											<i class=''fa fa-trash-o fa-lg'' style=''cursor:pointer;'' onclick=''deleteOD(' + cast(ODId as varchar) + ');''></i>' as acciones"
						desplegar			= "ODCodigo, ODDescripcion, Exclusivo,acciones"
						etiquetas			= "#LB_Codigo#,#LB_Desc#,#LB_Exclusivo#,&nbsp;"
						formatos			= "S,S,S,S"
						align 				= "left,left,center,center"
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
						keys				= "ODId"
						MaxRows				= "50"
						/>
						<br>
				<div class="">
					<input type="button"  onclick="funcNewOD(0,1)" value="Nuevo"
						class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto;">
				</div>
			</cfform>
		</cfoutput>
		</div>

		<div id="dialog-confirmEli"></div>
		<div id="popupViewEdit" style="display: none;"> <!---popUp Editar--->

		</div>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- JAVASCRIPT --->
<script language="javascript" type="text/javascript">

	function funcFiltrar(){
		var res;
			 res = true;
		return res;

	}

	    // $(location).attr('href',url);
	function formOD(ODId,option){
		// 1 = view, 2 = view, 3 = edit
		switch (option){
			case 1:
				var url = "OrigenDatos.cfm?varProc=NOD&ODID=0"
				break;
			case 2:
				var url = "OrigenDatos.cfm?varProc=VOD&ODID="+ODId
				break;
			case 3:
				var url = "OrigenDatos.cfm?varProc=EOD&ODID="+ODId
				break;
			default:
				var url = "listaOrigenDatos.cfm"
				break;
		}
	    $.ajax({
			type: "GET",
			url: url,
			success: function(result){
		        $("#popupViewEdit").html(result);
		    }
		});
		$("#popupViewEdit").dialog({
	        width: 600,
	        modal:true,
	        title:"<cfoutput>#LB_TituloVE#</cfoutput>",
	        resizable: "false",
	        position:['middle',20]
	    });
	}

	function deleteOD(ODId){
		$("#dialog-confirmEli").html("<cfoutput>#MSG_Eliminar#</cfoutput>");

	    $("#dialog-confirmEli").dialog({
	        resizable: false,
	        modal: true,
	        title: "<cfoutput>#LB_Eliminar#</cfoutput>",
	        height: 120,
	        width: 250,
	        buttons: {
	            "Si": function () {
	            	var url = "OrigenDatos-sql.cfm?Eliminar=1&ODID="+ODId;
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
	//Nuevo origen de datos
	 function funcNewOD(ODId,option){
	 	//ODId=0,option=1
		formOD(ODId,option);
	 }
</script>