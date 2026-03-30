
<cfoutput>

<cfparam name="form.subfix" default="">
<cfparam name="form.title" default="Configuracion de Cortes">
<cfparam name="url.Mcodigo" default="">

<cf_templateheader title="#form.title#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Configuracion de Cortes'>
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
	<cfset val = objParams.getParametroInfo('30200711')>
	<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
	<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>
	
	<cfquery name="checkRol" datasource="#session.dsn#">
		select * from UsuarioRol where 
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
				and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
	</cfquery>
	<cfif checkRol.recordCount neq 0>

		<cfset paramCods = [30000603,30000604,30000601,30000602]>
		<cfset paramTypes = ['TC','TM','D','D']>
		<cfset paramDesc = ['Tarjeta de Credito','Tarjeta Mayorista','Vales de Credito Q1','Vales de Credito Q2']>

			<cfquery name="rsParametros" datasource="#session.dsn#">
				SELECT id,Pcodigo,Mcodigo,Pvalor,Pdescripcion,Pcategoria,
				TipoDato,TipoParametro,Parametros
				FROM CRCParametros
				WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> and isNull(PSistema,0) <> 1 and isNull(PEspecial,0) = 1
					and Pcodigo in (#ArrayToList(paramCods,',')#)
				<cfif isdefined("url.Mcodigo") and url.Mcodigo neq "">
					and Mcodigo = '#url.Mcodigo#'
				</cfif>
			</cfquery>
			
			<cfquery name="rsCategorias" dbtype="query">
				select distinct Pcategoria from rsParametros
			</cfquery>
		
			<form action="ConfiguraCorte_sql.cfm?" method="post" name="form1" onsubmit=" return ValidarForm();" enctype="multipart/form-data">
				<input type="hidden" name="AfectarA" value="">
				<cfloop query="rsCategorias">
					<div class="row">
						<div class="col col-sm-12" >
							<div class="well">
								<div class="bs-example form-horizontal">
									<fieldset>
										<legend><b>#rsCategorias.Pcategoria#</b></legend>
										<cfquery name="rsParam" dbtype="query">
											select * from rsParametros
											where Pcategoria = '#rsCategorias.Pcategoria#'
										</cfquery>
										<cfloop query="rsParam">
											<div>
												<table border="0" width="100%">
													<tr>
														<td width="50%" align="right">#rsparam.Pdescripcion#:</td>
														<td width="1%"></td>
														<input type="hidden" name="h_#rsparam.Pcodigo#" value="#rsparam.Pvalor#">
														<td>#pintaParametro(rsparam.Pcodigo,rsparam.TipoDato,rsparam.TipoParametro,rsparam.Pvalor,rsparam.Parametros)#</td>
														<td></td>
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
				<div align="center">
					<input type="submit" name="Guardar" class="btnGuardar" value="Guardar">
					<input type="button" name="Descartar" class="btnDescartar" value="Descartar" onclick="Limpiar();">
				</div>
			</form>
	<cfelse>
		<cfthrow message="No cuentas con los permisos para realizar esta operacion">
	</cfif>	
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

	function ValidarForm(){
        var msg = 'Esta seguro que quiere cambiar la configuracion de:'
        var c = [];
        <cfloop array="#paramCods#" index="i" item="itm">
			if(document.getElementsByName('h_#paramCods[i]#').length > 0){
				var h = document.getElementsByName('h_#paramCods[i]#')[0].value;
				var f = document.getElementsByName('f_#paramCods[i]#')[0].value;
				if( h != f){
					msg += '\n- #paramDesc[i]# de ['+h+'] a ['+f+']';
					c.push('#paramTypes[i]#_#paramCods[i]#');
				}

			}
        </cfloop>

		if(c.length > 0){
            document.getElementsByName('AfectarA')[0].value = c.toString();
			return confirm(msg);
        }else{
            alert("No hay cambios que aplicar");
        }
        return false;
	}
	function Limpiar(){
        if(confirm('Seguro quiere revertir los cambios?')){
            <cfloop array="#paramCods#" index="i" item="itm">
                document.getElementsByName('f_#paramCods[i]#')[0].value = document.getElementsByName('h_#paramCods[i]#')[0].value;
            </cfloop>
        }
	}

</script>

</cfoutput>