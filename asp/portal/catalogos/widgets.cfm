<cf_templateheader title="Mantenimiento de Widgets">
	<cf_web_portlet_start titulo="Mantenimiento de Widgets">
<!--- INICIA CONTENIDO --->
<!--- Datos de la pagina --->
<cfquery name="rsSistemas" datasource="asp">
	select SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select SScodigo, SMcodigo, SMdescripcion
	from SModulos
	order by SMdescripcion
</cfquery>

<cfquery name="rsMenues" datasource="asp">
	select SScodigo, SMcodigo, SMNcodigo, <!---replicate(' ', SMNnivel*2) || SMNtitulo --->SMNtitulo
	from SMenues
	where SPcodigo is null
	order by SScodigo, SMcodigo, SMNpath, SMNorden
</cfquery>

<cfquery name="rsPos" datasource="asp">
	select WIDPosCodigo as WidPosicion,WIDPosDescripcion
	from WidgetPosicion
	order by WIDPosCodigo
</cfquery>

<cfset modo="ALTA">

	<div >
		<div class="row">
			<div class="col col-md-12">
				<form class="form-inline" role="form" id="form1" name="form1" method="post">
					<div class="form-group">
						<label for="widcodigo">C&oacute;digo:</label>
						<input type="text" id="widcodigo" name="widcodigo">
					</div>
					<div class="form-group">
						<label for="widtitulo">T&iacute;tulo:</label>
						<input type="text" id="widtitulo" name="widtitulo">
					</div>
					<div class="form-group">
						<label for="widpos">Posici&oacute;:</label>
						<select id="widpos" name="widpos">
							<option value=""> Todos</option>
							<cfoutput>
		                        <cfloop query="rsPos">
		                         	<option value="#trim(rsPos.WidPosicion)#" <cfif isdefined("form.widpos") and trim(form.widpos) eq trim(rsPos.WidPosicion)>selected</cfif>>#rsPos.WIDPosDescripcion#</option>
		                        </cfloop>
	                        </cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="fSScodigo">Sistema:</label>
						<select id="fSScodigo" name="fSScodigo">
                        	<option value="">Todos</option>
	                        <cfoutput>
		                        <cfloop query="rsSistemas">
		                         	<option value="#trim(rsSistemas.SScodigo)#" <cfif isdefined("form.fSScodigo") and trim(form.fSScodigo) eq trim(rsSistemas.SScodigo)>selected</cfif>>#rsSistemas.SScodigo#</option>
		                        </cfloop>
	                        </cfoutput>
                      </select>
					</div>
					<div class="form-group">
						<label for="fSMcodigo">Modulo:</label>
						<select id="fSMcodigo" name="fSMcodigo" >
                        	<option value="">Todos</option>
                        </select>
					</div>
					<div class="form-group">
						<div class="radio">
	                        <label>
	                          <input type="radio" name="optionsRadios" id="optionsRadios1" value="1" <cfif not isdefined('form.optionsRadios') or (isdefined('form.optionsRadios') and form.optionsRadios EQ '1')>checked</cfif>>
	                          Activos
	                        </label>
                        </div>
                        <div class="radio">
	                        <label>
	                          <input type="radio" name="optionsRadios" id="optionsRadios2" value="0" <cfif isdefined('form.optionsRadios') and form.optionsRadios EQ '0'>checked</cfif>>
	                          Inactivos
	                        </label>
                        </div>
                    </div>
					<div class="form-group">
						<cf_botones values="Filtrar">
					</div>
				</form>
				<cfset additionalCols = ''>
				<cfset filtro = '1 = 1'>
				<cfif isdefined('form.widcodigo') and trim(form.widcodigo) neq "">
					<cfset filtro = "#filtro# and upper(w.WidCodigo) like upper('%#form.widcodigo#%')">
				</cfif>
				<cfif isdefined('form.widtitulo') and trim(form.widtitulo) neq "">
					<cfset filtro = "#filtro# and upper(w.WidTitulo) like upper('%#form.widtitulo#%')">
				</cfif>
				<cfif isdefined('form.widpos') and trim(form.widpos) neq "">
					<cfset filtro = "#filtro# and w.WidPosicion = '#form.widpos#'">
				</cfif>
				<cfif isdefined('form.fSScodigo') and trim(form.fSScodigo) neq "">
					<cfset filtro = "#filtro# and w.SScodigo = '#form.fSScodigo#'">
				</cfif>
				<cfif isdefined('form.fSMcodigo') and trim(form.fSMcodigo) neq "">
					<cfset filtro = "#filtro# and w.SMcodigo = '#form.fSMcodigo#'">
				</cfif>
				<cfif isdefined('form.optionsRadios') and trim(form.optionsRadios) neq "">
					<cfset filtro = "#filtro# and w.WidActivo = #form.optionsRadios#">
				<cfelse>
					<cfset filtro = "#filtro#">
				</cfif>
				<cfset navegacion = ''>

				<cfinvoke
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 	value="Widget w
															left join WidgetPosicion wp
																on w.WidPosicion = wp.WIDPosCodigo
															left join SSistemas s
																on w.SScodigo = s.SScodigo
															left join SModulos m
																on w.SScodigo = m.SScodigo
																and w.SMcodigo = m.SMcodigo"/>
					<cfinvokeargument name="columnas" value="w.WidID,w.WidCodigo,w.WidTitulo,w.WidDescripcion,wp.WIDPosDescripcion as WidPosicion,
																case
																	when WidTipo = 'I' then 'Indicador'
																	else 'Contenido'
																end WidTipo,
																case
																	when w.WidActivo = 1 then '<i class=''fa fa-check-square-o fa-lg''></i>'
																	else '<i class=''fa fa-square-o fa-lg''></i>'
																end WidActivo,
																case
																	when  (w.SScodigo is null or m.SMcodigo is null) then 'Todos'
																	else ltrim(rtrim(w.SScodigo))+' - '+m.SMdescripcion
																end mostrar,
																case
																	when coalesce(w.WidMostrarOpciones,0) = 1 then '
																		<i class=''fa fa-cog fa-lg'' style=''cursor:pointer;'' onclick=''mostrarOpc(' + cast(w.WidID as varchar) + ');''></i>'
																end WidMostrarOpciones,
																'<i class=''fa fa-copy fa-lg'' style=''cursor:pointer;'' onclick=''copiarWid(' + cast(w.WidID as varchar) + ');''></i>&nbsp;
																<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''editarWid(' + cast(w.WidID as varchar) + ');''></i>&nbsp;
																<i class=''fa fa-trash-o fa-lg'' style=''cursor:pointer;'' onclick=''eliminarWid(' + cast(w.WidID as varchar) + ');''></i>' as acciones"/>
					<cfinvokeargument name="desplegar" value="WidCodigo, WidTitulo, WidDescripcion, WidTipo, WidPosicion, mostrar, WidActivo, WidMostrarOpciones, acciones"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, T&iacute;tulo, Descripci&oacute;n, Tipo, Posici&oacute;n,Se muestra en, Activo "/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="#filtro#"/>
					<cfinvokeargument name="align" value="left, left, left, left, left, left, center, center, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="showlink" value="false"/>
					<cfinvokeargument name="maxRows" value="80"/>
					<cfinvokeargument name="keys" value="WidID"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="checkall" value="S"/>
					<cfinvokeargument name="checkbox_function" value="funcChk(this)"/>
					<cfinvokeargument name="conexion" value="asp"/>
					<!--- <cfinvokeargument name="Cortes" value="mostrar"/> --->
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
					<cfinvokeargument name="debug" value="N"/>
				</cfinvoke>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12" align="center">
				<input type="button" name="btnNuevo" class="btnNuevo" value="Nuevo" onclick="return funcNuevo();" tabindex="0">
				<input type="button" name="btnAgregar" class="btnGuardar" value="Importar" onclick="return funcImportar();" tabindex="0">
				<input type="button" name="btnExportar" class="btnExportar" value="Exportar" onclick="return funcExportar();" tabindex="0">
			</div>
		</div>
		<div id="popupParametros" style="display: none;"> <!---popUp Editar---> </div>
		<div id="popupCopiar" style="display: none;"> <!---popUp Copiar--->
	        <label for="un" class="ui-hidden-accessible">C&oacute;digo:</label>
	        <input name="codigoW" id="codigoW" value="" placeholder="C&oacute;digo Widget" data-theme="a" type="text">
		</div>
		<div id="popupEditar" style="display: none;"> <!---popUp Editar---> </div>
		<div id="popupNuevo" style="display: none;"> <!---popUp Nuevo---> </div>
		<div id="popupExportar" style="display: none;"> <!---popUp Exportar---> </div>
		<div id="popupImportar" style="display: none;"> <!---popUp Importar---> </div>
		<div id="dialog-confirmEli"></div><!---Div para que salga el dialogo de eliminar el widgted--->
	</div>


<!--- scripts de la pagina --->
<script language="javascript1.2" type="text/javascript">
	<cfif isDefined('url.w')>
		<cfif url.w eq 0>
			alert("Ya existe un Widget registrado con el codigo <cfoutput>#url.msg#</cfoutput>");
		<cfelseif url.w eq -1>
			alert("No se pudo crear el widget: <cfoutput>#url.msg#</cfoutput>");
		<cfelse>
			alert("El widget se ha creado con exito");
		</cfif>
	</cfif>
	
	function change_sistema(obj){
		$('#fSMcodigo')
		    .find('option')
		    .remove()
		    .end()
		    .append('<option value="">Todos</option>');
	    <cfloop query="rsModulos">
		    if ( arguments[0] == '<cfoutput>#trim(rsModulos.SScodigo)#</cfoutput>' ) {
				$('#fSMcodigo').append('<option value=<cfoutput>#trim(rsModulos.SMcodigo)#</cfoutput>><cfoutput>#trim(rsModulos.SMdescripcion)#</cfoutput></option>')
					<cfif isdefined("form.fSMcodigo") and trim(rsModulos.SMcodigo) eq trim(form.fSMcodigo) >
				    	.val('<cfoutput>#trim(rsModulos.SMcodigo)#</cfoutput>')
				    </cfif>
				;
		    }
	    </cfloop>
	}

	function funcImportar(){
			$.ajax({
				type: "GET",
				url: "/cfmx/asp/portal/catalogos/widgets-import.cfm",
				success: function(result){
					$("#popupImportar").html(result);
				}
			});

			$("#popupImportar").dialog({
				width: 510,
				modal:true,
				title:"Importar Widgets",
				height: 250,
				resizable: "false",
			});
			
			return false;
	}

	function funcExportar(){
		var chkList = ValidarSeleccion();
		if(chkList.length > 0){
			$.ajax({
				type: "POST",
      			data: {chk:chkList.toString()} ,
				url: "/cfmx/asp/portal/catalogos/widgets-export.cfm",
				success: function(result){
					$("#popupExportar").html(result);
				}
			});

			$("#popupExportar").dialog({
				width: 510,
				modal:true,
				title:"Exportar Widgets",
				height: 400,
				resizable: "false",
			});
			$('#popupExportar').dialog('close');
			return false;
		}
		return false;
	}

	
    function ValidarSeleccion(){
        var checked = false;
		var chkList = [];
        var chks = document.getElementsByName('chk');
        for(var i in chks){ if(chks[i].checked){ checked = true; chkList.push(chks[i].value);} }
        if(!checked){
            alert("No ha seleccionado Widgets para exportar");
        }
        return chkList;
    }

    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

	$('#fSScodigo').change(function() {
		change_sistema($(this).val());
	});

	var vSScodigo = '';
	<cfif isdefined("form.fSScodigo")>
		vSScodigo = '<cfoutput>#trim(form.fSScodigo)#</cfoutput>';
	</cfif>
	// sistemas/modulos del filtro
	change_sistema(vSScodigo);

	function mostrarOpc(WidID)
	{
		$.ajax({
			type: "GET",
			url: "/cfmx/asp/portal/catalogos/widgets-param.cfm?WidID="+WidID,
			success: function(result){
		        $("#popupParametros").html(result);
		    }
		});

		$("#popupParametros").dialog({
	        width: 510,
	        modal:true,
	        title:"Editar Widgets",
	        resizable: "false"
	    });
	}

	function funcNuevo()
	{
	    $.ajax({
			type: "GET",
			url: "/cfmx/asp/portal/catalogos/widgets-form.cfm",
			success: function(result){
		        $("#popupNuevo").html(result);
		    }
		});

		$("#popupNuevo").dialog({
	        width: 510,
	        modal:true,
	        title:"Nuevo Widget",
	        height: 400,
	        resizable: "false",
	    });
		return false;
	}

	function copiarWid(WidID)
	{
	    $("#popupCopiar").dialog({
	        width: 250,
	        modal:true,
	        title:"Copiar Widgets",
	        height: 120,
	        resizable: "false",
	        buttons: {
	            "Copiar Widget": function () {
	            	var varWidCodigo= $("#codigoW").val();
	            	var url = "widgets-sql.cfm?imgCopiar=1&WidID="+WidID+"&codigo="+varWidCodigo;
					$(location).attr('href',url);
	                $(this).dialog('close');
	                callback(true);
	            }
	        }
	    });
	}

	function editarWid(WidID)
	{
		$.ajax({
			type: "GET",
			url: "/cfmx/asp/portal/catalogos/widgets-form.cfm?WidID="+WidID,
			success: function(result){
		        $("#popupEditar").html(result);
		    }
		});

		$("#popupEditar").dialog({
	        width: 510,
	        modal:true,
	        title:"Editar Widgets",
	        height: 400,
	        resizable: "false",
	    });
	}

	function eliminarWid(WidID)
	{
		$("#dialog-confirmEli").html("Deseas eliminar el widget??");

	    // Define the Dialog and its properties.
	    $("#dialog-confirmEli").dialog({
	        resizable: false,
	        modal: true,
	        title: "Eliminar Widgets",
	        height: 120,
	        width: 250,
	        buttons: {
	            "Si": function () {
	            	var url = "widgets-sql.cfm?imgEliminar=1&WidID="+WidID;
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
	}//termina Funcion eliminarWid
</script>


<!--- FIN CONTENIDO --->
	<cf_web_portlet_end>
<cf_templatefooter>