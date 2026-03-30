<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 27-1-2006.
		Motivo:  Se corrigen los tipo de datos de los campos OPtabla, OPtablaMayor que estaban usando char y son 
		varchar. También BMUsucodigo que estaba como char y es numeric.
--->

<cfparam name="Attributes.action" default="display">
<cfparam name="Attributes.tabla">
<cfparam name="Attributes.llave">
<cfparam name="Attributes.form" default="form1">
<cfparam name="Attributes.tabindex" default="-1">

<cfif Attributes.action is 'display' and ThisTag.ExecutionMode is 'START'>

<script type="text/javascript">
<!--


	var popUpWinCompFin=null;
	function popUpWindowCompFin(URLStr, left, top, width, height)
	{
		if(popUpWinCompFin) {
			if(!popUpWinCompFin.closed) popUpWinCompFin.close();
		}
		popUpWinCompFin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUpCompFin;
	}
	function closePopUpCompFin(){
		if(popUpWinCompFin) {
			if(!popUpWinCompFin.closed)
				popUpWinCompFin.close();
			popUpWinCompFin=null;
		}
	}

	function concateneCompFin(iname,names){
		var f = document.<cfoutput>#Attributes.form#</cfoutput>;
		var s = '';
		var nv = names.split(',');
		for(var i=0;i<nv.length;i++){
			<!--- alert("iname="+iname+",i="+i+",nv[i]="+nv[i]+",niveles="+niveles); --->
			if (nv[i].length) {
				if (f[nv[i]]) {
					s+=f[nv[i]].value;
				}
			}
		}
		f[iname].value=s;
	}
	var nameConlisNiveles = null;
	var nameConlisNivelesRef = null;
	
	function conlisNivelesCompFin(name, nivel, PCEcatid, PCNdep){
		var f = document.<cfoutput>#Attributes.form#</cfoutput>;
		nameConlisNiveles = name + '_' + nivel;
		nameConlisNivelesRef = name + '_' + nivel + '_ref';
		if (PCEcatid != 0 && PCNdep == 0){
			window.open('/cfmx/sif/ad/origenes/ConlisCuentasFinancierasNivel.cfm?nivel='+nivel
				+'&Ecodigo=<cfoutput>#session.Ecodigo#</cfoutput>'
				+'&CatalogoID='+PCEcatid
				+'&nivelDepende='+PCNdep, 'clcatalogoX','width=800,height=400');
		} else if (PCNdep != 0) {
			window.open('/cfmx/sif/ad/origenes/ConlisCuentasFinancierasSubNivel.cfm?nivel='+nivel
				+'&Ecodigo=<cfoutput>#session.Ecodigo#</cfoutput>'
				+'&nivelDepende='+PCNdep
				+'&RefId='+f[name + '_' + (nivel-1) + '_ref'].value
				+'&RefValor='+f[name + '_' + (nivel-1)].value, 'clcatalogoX','width=800,height=400');
		}
	}

<!---
	2010-07-13
	obonilla66:	Esta corrección la hice pero no por que, la dejo por si se vuelve a presentar el problema:
	
	function conlisNivelesCompFin(name, nivel, PCEcatid, PCNdep){
		var f = document.<cfoutput>#Attributes.form#</cfoutput>;
		nameConlisNiveles = name + '_' + nivel;
		nameConlisNivelesRef = name + '_' + nivel + '_ref';
		nameConlisNivelesAnt = name + '_' + (nivel-1);
		nameConlisNivelesRefAnt = name + '_' + (nivel-1) + '_ref';
		if (PCEcatid != 0 && PCNdep == 0){
			window.open('/cfmx/sif/ad/origenes/ConlisCuentasFinancierasNivel.cfm?nivel='+nivel
				+'&Ecodigo=<cfoutput>#session.Ecodigo#</cfoutput>'
				+'&CatalogoID='+PCEcatid
				+'&nivelDepende='+PCNdep, 'clcatalogoX','width=800,height=400');
		} else if (PCNdep != 0) {
			window.open('/cfmx/sif/ad/origenes/ConlisCuentasFinancierasSubNivel.cfm?nivel='+nivel
				+'&Ecodigo=<cfoutput>#session.Ecodigo#</cfoutput>'
				+'&nivelDepende='+PCNdep
				+'&RefId='+f[nameConlisNivelesRef].value
				+'&RefValor='+f[nameConlisNiveles].value, 'clcatalogoX','width=800,height=400');
		}
	}
--->	

	function sbResultadoConLisCFnivel(valor, descripcion, nivel, ref) {
		document.<cfoutput>#Attributes.form#</cfoutput>[nameConlisNiveles].value=valor;
		document.<cfoutput>#Attributes.form#</cfoutput>[nameConlisNivelesRef].value=ref;
		closePopUpCompFin();
		// concatenar usando onfocus
		try{
		document.<cfoutput>#Attributes.form#</cfoutput>[nameConlisNiveles].focus();
		} catch(e){
		}
	}
//-->
</script>
	<cffunction name="pintar_complemento">
		<cfargument name="name"          required="yes">
		<cfargument name="ODcomplemento" required="yes">
		<cfargument name="QueryNiveles"  required="yes" type="query">

		<cfoutput>
			<input tabindex="-1"  type="hidden" name="#name#" size="8" maxlength="15" value="#ODcomplemento#" >
		</cfoutput>
			<!--- #ODcomplemento# #mascara# --->
		<script type="text/javascript">
			function <cfoutput>#Arguments.name#</cfoutput>_func(ctamayor){
			<cfoutput query="Arguments.QueryNiveles" group="Cmayor"  >
				if(ctamayor=='#trim(Arguments.QueryNiveles.Cmayor)#'){
					document.getElementById('#Arguments.name#_#Arguments.QueryNiveles.Cmayor#_div').style.display=''
				}
				else{
					document.getElementById('#Arguments.name#_#Arguments.QueryNiveles.Cmayor#_div').style.display='none'
				}
			</cfoutput>
			}
		</script>
		<cfoutput query="Arguments.QueryNiveles" group="Cmayor"  >
			<cfset posicionactual=1>
			<div  id="#Arguments.name#_#Arguments.QueryNiveles.Cmayor#_div" style=" display:">
			<cfset names=''>
			<cfoutput>
				<cfset names=ListAppend(names,"#name#_#Arguments.QueryNiveles.Cmayor#_#Arguments.QueryNiveles.OPnivel#")>
			</cfoutput>
			<cfset nivel_mascara = 1>
				<strong><cf_translate  key="LB_Cuenta">Cuenta</cf_translate> #Arguments.QueryNiveles.Cmayor# - #Arguments.QueryNiveles.Cdescripcion#
				<br> (#Arguments.QueryNiveles.Cmayor#-#ListRest(UCase(Cmascara),'-')#)</strong><br>
			<cfoutput>
				<!--- QueryNiveles: (Cmayor,OPnivel,PCEcatid,PCNdep,Cmascara) --->
				<cfset longcampo = 4>
				<cftry><cfset longcampo=Len(ListGetAt(Arguments.QueryNiveles.Cmascara,Arguments.QueryNiveles.OPnivel+1,'-'))>
				<cfcatch type="any">#cfcatch.Message#, <em>ListGetAt(#Arguments.QueryNiveles.Cmascara#,#Arguments.QueryNiveles.OPnivel#+1,'-')</em></cfcatch>
				</cftry>
				<cfif nivel_mascara LE Arguments.QueryNiveles.OPnivel-1>
					<cfloop from="#nivel_mascara#" to="#Arguments.QueryNiveles.OPnivel-1#" index="pintanivel">
						<cfif pintanivel GT 1>-</cfif>#UCase(ListGetAt(Arguments.QueryNiveles.Cmascara,pintanivel+1,'-'))#
					</cfloop>
				</cfif>
				
				<cfset nivel_mascara = Arguments.QueryNiveles.OPnivel + 1>
				
				<cfset valoractual=Mid(ODcomplemento,posicionactual,longcampo)>
				<cfset posicionactual=posicionactual+longcampo>
				<cfif Arguments.QueryNiveles.OPnivel GT 1>-</cfif>
				<input tabindex='<cfoutput>#attributes.tabindex#</cfoutput>' type="text" size="3" maxlength="#longcampo#" name="#name#_#Arguments.QueryNiveles.Cmayor#_#Arguments.QueryNiveles.OPnivel#" 
				value="#valoractual#" onchange="concateneCompFin('#Arguments.name#','#names#')"
				onfocus="concateneCompFin('#Arguments.name#','#names#')" >
				<input tabindex="-1"  type="hidden" size="3" name="#Arguments.name#_#Arguments.QueryNiveles.Cmayor#_#Arguments.QueryNiveles.OPnivel#_ref"
				value="#Arguments.QueryNiveles.PCEcatid#" >
				<cfif Arguments.QueryNiveles.PCEcatid neq 0 or Arguments.QueryNiveles.PCNdep neq 0>
				<a href="javascript:conlisNivelesCompFin('#Arguments.name#_#Arguments.QueryNiveles.Cmayor#', #Arguments.QueryNiveles.OPnivel#, #
				Arguments.QueryNiveles.PCEcatid#, #Arguments.QueryNiveles.PCNdep#)">
				<img src="/cfmx/sif/imagenes/Description.gif" width="18" height="14" border="0">
				</a>
				</cfif>
			</cfoutput>
			<cfif nivel_mascara LE ListLen(Arguments.QueryNiveles.Cmascara,'-')>
				<cfloop from="#nivel_mascara#" to="#ListLen(Arguments.QueryNiveles.Cmascara,'-')-1#" index="pintanivel">
					-#UCase(ListGetAt(Arguments.QueryNiveles.Cmascara,pintanivel+1,'-'))#
				</cfloop>
			</cfif>
				<br>
			</div>	
		</cfoutput>
	</cffunction>

	<!--- Verifica si hay  hay registros en la tabla  OrigenDatos --->
	<!--- Para pintarlos en modo cambio                           --->
	<cfquery name="RSOrigenDatos"  datasource="#Session.DSN#">
		Select   Oorigen,Cmayor,ODcomplemento  from  OrigenDatos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and OPtabla = <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
		and ODchar = <cfqueryparam value="#Attributes.llave#" cfsqltype="cf_sql_varchar">
	</cfquery>	
	
	<!--- Query que saca todos los origenes que tiene el catalogo selecionado --->
	<cfquery name="RSTOrigen" datasource="#Session.DSN#">
		select  distinct  a.Oorigen,Cdescripcion from OrigenDocumentos a ,ConceptoContable b
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and OPtablaMayor = <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
			and a.Ecodigo = b.Ecodigo
			and a.Oorigen = b.Oorigen 
		union
		select  distinct a.Oorigen,Cdescripcion   from OrigenNivelProv a ,ConceptoContable b
		where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		and OPtabla = <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
			and a.Ecodigo = b.Ecodigo
			and a.Oorigen = b.Oorigen
		order by 	1 	
	</cfquery>
	<cfset OorigenL = ''>
	<!--- mete en una lista los origenes para ser usados en el insert --->
	<cfif RSTOrigen.recordcount gt 0>
		<cfloop query="RSTOrigen">
			<cfset OorigenL = OorigenL & RSTOrigen.Oorigen & ',' >
		</cfloop>
	</cfif>

	<table width="90%"  border="0" cellspacing="0" cellpadding="2">
	<tr valign="top" class="tituloListas"><td align="right" class="tituloListas"><cf_translate  key="LB_OrigenDeTransaccion">Origen de Transacción</cf_translate>&nbsp;&nbsp;</td>
	<td align="center" class="tituloListas"><cf_translate  key="LB_Cuenta">Cuenta</cf_translate></td>
	<td class="tituloListas"><cf_translate  key="LB_Complementos">Complemento (s)</cf_translate></td>
	</tr>
		<cfloop query="RSTOrigen">
			<cfset CuentasLista = ''>
			<!--- Busca si el catalogo esta definido con la cuenta mayor     --->
			<cfquery name="RSCuentasOri" datasource="#Session.DSN#">
				select  b.Cmayor  from OrigenDocumentos a ,OrigenCtaMayor  b
				where a.Ecodigo =   <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and OPtablaMayor =  <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
				and a.Ecodigo = b.Ecodigo
				and a.Oorigen = b.Oorigen 						
				and a.Oorigen   = <cfqueryparam value="#RSTOrigen.Oorigen#" cfsqltype="cf_sql_char">
				order by b.Cmayor
			</cfquery>		

			<!--- Busca si el catalogo esta definido en algun nivel     --->
			<cfquery name="RSCuentasNiv" datasource="#Session.DSN#">
				select a.Cmayor, cm.Cdescripcion, a.OPnivel, 
					coalesce (
						(
						select min(cpv.CPVformatoF)
						from CPVigencia cpv
						where cpv.Ecodigo = cm.Ecodigo
						  and cpv.Cmayor = cm.Cmayor
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and CPVhasta
						), 'XXXX') as Cmascara, coalesce (nm.PCEcatid, 0) as PCEcatid, coalesce (nm.PCNdep, 0) as PCNdep
				from OrigenNivelProv a
					join CtasMayor cm
						on a.Cmayor = cm.Cmayor
						and a.Ecodigo = cm.Ecodigo
					left join PCNivelMascara nm
						on nm.PCEMid = cm.PCEMid
						and nm.PCNid = a.OPnivel
				where a.Ecodigo =  <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and OPtabla     =  <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
				and a.Oorigen   =  <cfqueryparam value="#RSTOrigen.Oorigen#" cfsqltype="cf_sql_char">
				order by a.Cmayor, a.OPnivel
			</cfquery>

			<!--- Busca si el catalogo esta definido tanto en la cuenta mayor como en un nivel    --->
			<!--- pinta combo y imput    --->
			<cfif RSCuentasOri.recordcount gt 0 and RSCuentasNiv.recordcount gt 0>
				<cfset ODcomplemento=''>
				<cfif RSOrigenDatos.recordcount gt 0>
					<cfquery name="RSOrigenDatos2"   dbtype="query">
						Select   Cmayor,ODcomplemento  from  RSOrigenDatos
						where Oorigen = <cfqueryparam value="#RSTOrigen.Oorigen#" cfsqltype="cf_sql_char">
					</cfquery>				
					<cfset ODcomplemento=RSOrigenDatos2.ODcomplemento>
				</cfif>
				<tr valign="top">
					<td   align="right"  nowrap><cfoutput>#RSTOrigen.Cdescripcion#:</cfoutput></td>
					<td >
						<select tabindex='<cfoutput>#attributes.tabindex#</cfoutput>' onChange="javascript: Complemento_<cfoutput>#RSTOrigen.Oorigen#</cfoutput>_func(this.value);"name="Cmayor_<cfoutput>#RSTOrigen.Oorigen#</cfoutput>" >
						<cfif not isdefined("RSOrigenDatos2")>
							<option value="">Seleccione una cuenta</option>
						</cfif>
						<cfloop query="RSCuentasOri">
							<option value="<cfoutput>#RSCuentasOri.Cmayor#</cfoutput>" <cfif isdefined("RSOrigenDatos2") and RSOrigenDatos2.recordcount gt 0 and RSOrigenDatos2.Cmayor eq RSCuentasOri.Cmayor >selected</cfif>><cfoutput>#RSCuentasOri.Cmayor#</cfoutput></option>
						</cfloop>
						</select>	
				  </td>
					<td nowrap>
						<cfset pintar_complemento("Complemento_" & RSTOrigen.Oorigen, ODcomplemento, RSCuentasNiv )>
							<script type="text/javascript">
								<cfoutput>Complemento_#RSTOrigen.Oorigen#_func(document.#Attributes.form#.Cmayor_#RSTOrigen.Oorigen#.value);</cfoutput>
							</script>
						<cfset CuentasLista = '' >
				  </td>
				</tr>
			<!--- Busca si el catalogo esta definido solo en la cuenta mayor --->
			<!--- pinta combo    --->
			<cfelseif  RSCuentasOri.recordcount gt 0 and RSCuentasNiv.recordcount eq 0>
				<cfif RSOrigenDatos.recordcount gt 0>
					<cfquery name="RSOrigenDatos2"   dbtype="query">
						Select   Cmayor  from  RSOrigenDatos
						where Oorigen = <cfqueryparam value="#RSTOrigen.Oorigen#" cfsqltype="cf_sql_char">
					</cfquery>				
				</cfif>
				 <tr valign="top">
					<td width="45%" align="right"  nowrap><cfoutput>#RSTOrigen.Cdescripcion#:</cfoutput></td>
					<td width="10%">
						<select tabindex='<cfoutput>#attributes.tabindex#</cfoutput>' name="Cmayor_<cfoutput>#RSTOrigen.Oorigen#</cfoutput>" >
						<cfif not isdefined("RSOrigenDatos2")>
							<option value="">Seleccione una cuenta</option>
						</cfif>
						<cfoutput query="RSCuentasOri">
							<option  value="#RSCuentasOri.Cmayor#" <cfif isdefined("RSOrigenDatos2") and RSOrigenDatos2.recordcount gt 0 and RSOrigenDatos2.Cmayor eq RSCuentasOri.Cmayor >selected</cfif>  >#RSCuentasOri.Cmayor#</option>
						</cfoutput>
						</select>	
				   </td>
					<td width="45%">
						<cfoutput>
						<input tabindex="-1"  type="hidden" name="Complemento_#RSTOrigen.Oorigen#" value="">
					  </cfoutput>
						<cfset CuentasLista = '' >
				   </td>
					
				</tr>	
			<!--- Busca si el catalogo esta definido solo en los niveles --->
			<!--- pinta lista de cuentas y imputs    --->
			<cfelseif  RSCuentasOri.recordcount eq 0 and RSCuentasNiv.recordcount gt 0>
				<cfset descripcion = RSTOrigen.Cdescripcion>
				<cfset Oorigen_V = RSTOrigen.Oorigen>
				<cfoutput query="RSCuentasNiv" group="Cmayor">
					<cfset ODcomplemento=''>
					<cfif RSOrigenDatos.recordcount gt 0>
						<cfquery name="RSOrigenDatos2"   dbtype="query">
							Select   ODcomplemento  from  RSOrigenDatos
							where Oorigen = '#Oorigen_V#'
							and Cmayor =  '#RSCuentasNiv.Cmayor#'
						</cfquery>
						<cfset ODcomplemento=RSOrigenDatos2.ODcomplemento>
					</cfif>
					<tr valign="top">
						<td width="45%" align="right"  nowrap>#descripcion#:</td>
						<td width="10%" align="center" ><strong>#RSCuentasNiv.Cmayor#</strong></td>
						<td width="45%" nowrap>
							<cfquery dbtype="query" name="EstaCuentaMayor">
								select Cmayor,Cdescripcion,OPnivel,PCEcatid,PCNdep,Cmascara
								from RSCuentasNiv
								where Cmayor = '#RSCuentasNiv.Cmayor#'
							</cfquery>
							<cfset pintar_complemento("Complemento_#Oorigen_V#_#RSCuentasNiv.Cmayor#", ODcomplemento, EstaCuentaMayor)>
					  </td>
					</tr>
					<cfset CuentasLista = CuentasLista& RSCuentasNiv.Cmayor & ',' >
				</cfoutput>	 
			</cfif>
			<cfoutput>
			<input tabindex="-1"  type="hidden" name="CuentasList_#RSTOrigen.Oorigen#" value="#CuentasLista#">
			</cfoutput>
		</cfloop>
		<!---
		<tr valign="top">	
			<td colspan="3" align="center">
			
			<iframe name="clcatalogo" src="about:blank" width="800" height="400"></iframe>
			
			</td>
		</tr>--->
  </table>


	<cfoutput>
		<input tabindex="-1"  type="hidden" name="OPtabla" value="#Attributes.tabla#">
		<input tabindex="-1"  type="hidden" name="ODchar" value="#Attributes.llave#">
		<input tabindex="-1"  type="hidden" name="Oorigen" value="#OorigenL#">
	</cfoutput>

<cfelseif Attributes.action is 'update' and ThisTag.ExecutionMode is 'START'>	
	<cfquery name="RSQuerys" datasource="#Session.DSN#">
		delete from OrigenDatos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and OPtabla = <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
		and ODchar = <cfqueryparam value="#Attributes.llave#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset list_Origen = listtoarray(Form.Oorigen,",")>
	<cfloop from="1" to ="#arraylen(list_Origen)#" index="i">
		<cfset list_Cuentas = listtoarray(FORM['CuentasList_#list_Origen[i]#'],",")>
		<cfif	arraylen(list_Cuentas) gt 0>
			<cfloop from="1" to ="#arraylen(list_Cuentas)#" index="C">
				<cfquery name="RSQuerys" datasource="#Session.DSN#">
					insert into OrigenDatos (   
						Ecodigo,  
						Oorigen,
						OPtabla,
						Cmayor,
						ODcomplemento,
						ODchar,
						BMUsucodigo
					)
					values(
						<cfqueryparam value="#Session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#list_Origen[i]#" 	cfsqltype="cf_sql_char">,
						<cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#list_Cuentas[C]#" 	cfsqltype="cf_sql_char">,
						<cfqueryparam value="#FORM['Complemento_#list_Origen[i]#_#list_Cuentas[C]#']#" 	cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Attributes.llave#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#session.Usucodigo#" 	cfsqltype="cf_sql_numeric">
					)		
				</cfquery>	 
			</cfloop>
		<cfelseif StructKeyExists(FORM, 'Cmayor_' & list_Origen[i] )>
			<!--- este IF se agregó posteriormente para que no de errores por falta de parametrización --->
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				insert into OrigenDatos (   
					Ecodigo,  
					Oorigen,
					OPtabla,
					Cmayor,
					ODcomplemento,
					ODchar,
					BMUsucodigo
				)
				values(
					<cfqueryparam value="#Session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#list_Origen[i]#" 	cfsqltype="cf_sql_char">,
					<cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#FORM['Cmayor_#list_Origen[i]#']#" 	cfsqltype="cf_sql_char">,
					<cfqueryparam value="#FORM['Complemento_#list_Origen[i]#']#" 	cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Attributes.llave#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#session.Usucodigo#" 	cfsqltype="cf_sql_numeric">
				)		
			</cfquery>	 
		</cfif>	
	</cfloop>
<cfelseif Attributes.action is 'delete' and ThisTag.ExecutionMode is 'START'>
	<cfquery name="RSQuerys" datasource="#Session.DSN#">
		delete from OrigenDatos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and OPtabla = <cfqueryparam value="#Attributes.tabla#" cfsqltype="cf_sql_varchar">
		and ODchar = <cfqueryparam value="#Attributes.llave#" cfsqltype="cf_sql_varchar">
	</cfquery>	
<cfelseif ThisTag.ExecutionMode is 'START'>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_InvocacionInvalidaDeCf_sifcomplementofinancieroAtributosUsados"
	Default="Invocacion invalida de cf_sifcomplementofinanciero. Atributos usados:"
	returnvariable="MSG_InvocacionInvalidaDeCf_sifcomplementofinancieroAtributosUsados"/>


	<cf_errorCode	code = "50701"
					msg  = "@errorDat_1@ @errorDat_2@"
					errorDat_1="#MSG_InvocacionInvalidaDeCf_sifcomplementofinancieroAtributosUsados#"
					errorDat_2="#StructKeyList(Attributes)#"
	>

</cfif>

