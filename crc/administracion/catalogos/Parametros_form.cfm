<cfparam name="form.subfix" default="">
<cfparam name="form.title" default="Parametros">
<cfparam name="url.Mcodigo" default="">
<cfparam name="url.Desc" default="">

<cf_templateheader title="#form.title#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Par&aacute;metros Generales del Sistema'>
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfquery name="rsParametros" datasource="#session.dsn#">
			SELECT id,Pcodigo,Mcodigo,Pvalor,Pdescripcion,Pcategoria,
		       TipoDato,TipoParametro,Parametros
			FROM CRCParametros
			WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> and isNull(PSistema,0) <> 1 and isNull(PEspecial,0) <> 1
			<cfif isdefined("url.Mcodigo") and url.Mcodigo neq "">
				and Mcodigo = '#url.Mcodigo#'
			</cfif>
			<cfif isdefined("url.Desc") and url.Desc neq "">
				and upper(Pdescripcion) like upper('%#url.Desc#%')
			</cfif>
		</cfquery>
		
		<cfquery name="rsModulos" datasource="asp">
			select m.SMcodigo, m.SMdescripcion
			from SModulos m
			inner join ModulosCuentaE ce
				on m.SScodigo = ce.SScodigo
				and m.SMcodigo = ce.SMcodigo
			where m.SScodigo = 'CRED'
				and ce.CEcodigo = #Session.CEcodigo#
		</cfquery>
<cfoutput>
		<form action="Parametros_sql.cfm?Mcodigo=#url.Mcodigo#&Desc=#url.Desc#" method="post" name="form1" onsubmit=" return FrameFunction();" enctype="multipart/form-data">
			<div class="col-md-8" style="margin:15px">
				<div class="form-group">
					<label>Modulo: </label>
					<select name="listmod" id="listmod" onchange="changelistmod()">
						<option value=""> - Todos los Modulos -</option>
						<cfloop query="rsModulos">
							<option value="#SMcodigo#" 
								<cfif isdefined("url.Mcodigo") and trim(url.Mcodigo) eq "#trim(SMcodigo)#"> selected </cfif> > 
								#SMdescripcion#
							</option>
						</cfloop>
					</select>
					<label>Descripci&oacute;n: </label>
					<input type="text" id="filtroDesc" name="filtroDesc" value="#trim(url.Desc)#"/>
					<input type="button"  name="btnFiltro" value="Filtrar" onClick="changelistmod()"/>
				</div>
			</div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfloop query="rsModulos">
							<cfquery dbtype="query" name="rsParametro">
								select * from rsParametros
								where Mcodigo = '#trim(rsModulos.SMcodigo)#'
							</cfquery>
							<cfif rsParametro.recordcount gt 0>
								<section>
									<div class="CG">
										<table border="0" width="99%" align="center">
											<tr>
												<td colspan="3" class="listaImPar" align="center" ><b>Modulo: #rsModulos.SMdescripcion#</b></td>
											</tr>
											<tr>
												<td>
													<cfquery name="rsCategorias" dbtype="query">
														select distinct Pcategoria from rsParametro
													</cfquery>
													<cfloop query="rsCategorias">
													<div class="row">
														<div class="col col-sm-12" >
															<div class="well">
																<div class="bs-example form-horizontal">
														    		<fieldset>
														    			<legend><b>#rsCategorias.Pcategoria#</b></legend>
														    			<cfquery name="rsParam" dbtype="query">
																			select * from rsParametro
																			where Pcategoria = '#rsCategorias.Pcategoria#'
																		</cfquery>
																		<cfloop query="rsParam">
																			<div>
																				<table border="0" width="100%">
																					<tr>
																		            	<td width="50%" align="right">#rsparam.Pdescripcion#:</td>
																						<td width="1%"></td>
																						<td>#pintaParametro(rsparam.Pcodigo,rsparam.TipoDato,rsparam.TipoParametro,rsparam.Pvalor,rsparam.Parametros)#</td>
																					</tr>
																				</table>
																			</div>
																		</cfloop>
																	</fieldset>
																</div>
															</div>
														</div>
													</div>
													</cfloop>
												</td>
											</tr>
										</table>
									</div>
								</section>
							</cfif>
						</cfloop>
					</td>
				</tr>
				<tr>
					<td>
						<div align="center">
							<input type="submit" name="Aceptar" class="btnGuardar" value="Aceptar">
						</div>
					</td>
				</tr>
			</table>
		</form>
</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>


<!--- funciones --->
<cffunction name="pintaParametro">
	<cfargument name="Codigo" required="true">
	<cfargument name="TipoDato" required="true"> <!--- T:Texto; B:Boleano; E:Numero entero; D:Numero con decimales;F:Fecha --->
	<cfargument name="TipoParametro" required="true"> <!--- F:Valor Fijo; R:Valor Fijo que se seleccion de un rango; L:lista de valores separados por ','; P:Personalizado --->
	<cfargument name="Valor" required="true">
	<cfargument name="Parametros" required="true"> <!--- Parametros segun el tipo deParametro --->
	<cfoutput>
		<cfif Arguments.TipoDato eq "F">
			<cf_sifcalendario form="form1" value="#Arguments.valor#" name="f_#Arguments.Codigo#">
		<cfelseif Arguments.TipoDato eq 'A'>
			<textarea name="f_#Arguments.Codigo#" rows="5" cols="50" maxlength="250">
#Arguments.Valor#
			</textarea> 
		<cfelseif ListContains("R,L,Q", Arguments.TipoParametro) or Arguments.TipoDato eq "B">
			<cfif len(trim(Arguments.Parametros)) gt 0 or Arguments.TipoDato eq "B">
				<select name="f_#Arguments.Codigo#">
					<option value=""><cf_translate key="LB_Seleccione" XmlFile="/crc/generales.xml"> -- Seleccione --</cf_translate></option>
					<cfif Arguments.TipoDato eq "B">
						<option value="S" <cfif arguments.Valor eq 'S'> selected </cfif>>Si</option>
						<option value="N" <cfif arguments.Valor eq 'N'> selected </cfif>>No</option>
					<cfelseif Arguments.TipoParametro eq "Q">
						<cftry>
							<cfset strSQL = PreserveSingleQuotes(Arguments.Parametros)>
							<cfset arrVar = GetVariables(strSQL)>

							<cfloop from="1" to="#arraylen(arrVar)#" index="i">
								<cfset vValue = evaluate(evaluate("arrVar[#i#]"))>
								<cfset strSQL = replaceNoCase(strSQL,evaluate("arrVar[#i#]"),'#evaluate(vValue)#','all')>
							</cfloop>

							<cftransaction>
							<cfquery name="rsOpt" datasource="#session.dsn#">
								#PreserveSingleQuotes(strSQL)#
							</cfquery>
							<cftransaction action="rollback">
							<cfset dataQuery="#getmetadata(rsOpt)#">
							<cfloop query="rsOpt">
								<cfset f1 = rsOpt['#dataQuery[1].Name#'][currentrow]>
								<cfset f2 = rsOpt['#dataQuery[2].Name#'][currentrow]>
								<cfset opt = "<option value='#f1#'">
								<cfif trim(arguments.Valor) eq trim(f1)> <cfset opt = "#opt# selected "></cfif>

								<cfset opt = opt &  ">#f2#</option>">
								#opt#
							</cfloop>
						<cfcatch>
							<!--- <label>Error de configuracion en el Parametro</label> --->
						</cfcatch>
						</cftry>
					<cfelse>
						<cfset arrOpt=ArrayNew(1)>
						<cfset arrRangos = listToArray(Arguments.Parametros,',',false)>
						<cfif Arguments.TipoParametro eq "R">
							<cfloop array="#arrRangos#" index="i">
								<cfset lRango = listtoArray(i,"-",false)>
								<cfloop index="loopCount" from="#lRango[1]#" to="#lRango[2]#">
									<cfset ArrayAppend(arrOpt,loopCount)>
								</cfloop>
							</cfloop>
							<cfloop array="#arrOpt#" index="i">
								<option value="#i#" <cfif arguments.Valor eq i> selected </cfif>>#i#</option>
							</cfloop>
						<cfelse>
							<cfloop array="#arrRangos#" index="i">
								<cfset arrMap = listtoArray(i,":",false)>
								<cfset ArrayAppend(arrOpt,arrMap)>
							</cfloop>
							<cfloop array="#arrOpt#" index="j">
								<option value="#j[1]#" <cfif arguments.Valor eq j[1]> selected </cfif>>
									<cfif ArrayLen(j) gt 1>#j[2]#<cfelse>#j[1]#</cfif>
								</option>
							</cfloop>
						</cfif>
					</cfif>

				</select>
			<cfelse>
				<label>Error de configuracion en el Parametro</label>
			</cfif>
		<cfelseif Arguments.TipoParametro eq "P">
			<cftry>
				<cfinclude template="include/#Arguments.codigo#.cfm">
			<cfcatch>
				<label>Error de configuracion en el Parametro #cfcatch.message#</label>
			</cfcatch>
			</cftry>

		<cfelse>
			<input name="f_#Arguments.Codigo#" value="#Arguments.Valor#"
				<cfif Arguments.TipoDato eq 'D'>
					class="decimalInput" style="text-align:right"
				<cfelseif  Arguments.TipoDato eq 'E'>
					onkeypress="return soloNumeros(event);" style="text-align:right"
				</cfif>>
		</cfif>

	</cfoutput>

</cffunction>

<cffunction name="GetVariables" access="private" returntype="array" output="no">
	<!--- <cfargument name="COID" 	type="numeric" 	required="no"> --->
	<cfargument name="Variables" 	type="string" 	required="no">
	<!--- Obteniendo arreglo de variables --->
	<cfset Lvartext	= Arguments.Variables>
	<cfset result = REMatch("(?s)##.*?##", Lvartext)>
	<!--- Arreglos auxiliares --->
	<cfset LvarArraySal=ArrayNew(1)>
	<!--- Validando variables no repetidas --->
	<cfloop array=#result# index="valor">
		<cfset LvarVariables= reReplace(valor,"<|>|[?]","","All")>
		<cfif ListFind(ArrayToList(LvarArraySal), LvarVariables) eq 0>
		<cfset ArrayAppend(LvarArraySal, LvarVariables)>
		</cfif>
	</cfloop>

	<cfreturn LvarArraySal>
</cffunction>

<script type="text/javascript">

	$('.decimalInput').keypress(function(eve) {
  		if ((eve.which != 8 && eve.which != 0) && (eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0) ) {
	    	eve.preventDefault();
	  	}
	});

	// this part is when left part of number is deleted and leaves a . in the leftmost position. For example, 33.25, then 33 is deleted
 	$('.decimalInput').keyup(function(eve) {
  		if($(this).val().indexOf('.') == 0) {
  			$(this).val($(this).val().substring(1));
  		}
 	});


	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}

	function changelistmod(){
		var lvarMod = document.getElementById("listmod").value.trim();
		var lvarDesc = document.getElementById("filtroDesc").value.trim();
		window.location.href = 'Parametros.cfm?Mcodigo='+lvarMod+'&Desc='+lvarDesc;
	}

</script>