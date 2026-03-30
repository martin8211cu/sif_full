<cfif modo eq "CAMBIO" or modo eq "ALTA">
<cfparam name="Form.CJX20NUM" default="-1">
	<!---************************ --->
	<!---** TOTALES DE RELACION ** --->
	<!---************************ --->
	<cfset DIGITADO = "0.00">
	<cfset GASTOS = "0.00">
	<cfset DIFERENCIA = "0.00">
	<cfset ANTICIPOS = "0.00">
		<cfquery name="rsDigitado" datasource="#session.Fondos.dsn#">
			select convert(varchar(20),isnull(sum(CJX20MNT),0),1) CJX20MNT
			from CJX019, CJX020
			where CJX019.CJX19REL = CJX020.CJX19REL
			and CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
			and CJX19EST ='P'
		</cfquery>
		<cfset DIGITADO = "#rsDigitado.CJX20MNT#">
		
		<cfquery name="rsGastos" datasource="#session.Fondos.dsn#">
			select convert(varchar(20),isnull(sum(CJX20MNT),0),1) CJX20MNT
			from CJX020
			where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
		</cfquery>
		<cfset GASTOS = "#rsGastos.CJX20MNT#">
		
		<cfquery name="rsAnticipos" datasource="#session.Fondos.dsn#">
			select convert(varchar(20),isnull(sum(CJX23MON * (case when CJX23TTR = 'D' then -1 else 1 end)),0),1) CJX23MON
			from CJX023
			where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
		</cfquery>
		<cfset ANTICIPOS = "#rsAnticipos.CJX23MON#">
		
		<cfset DIFERENCIA = #LSCurrencyFormat(replace(rsGastos.CJX20MNT,",","","All") - replace(rsAnticipos.CJX23MON,",","","All"),"None")#>
	
	<!---********************************* --->
	<!---** para entrar en mododet cambio  ** --->
	<!---********************************* --->
	<cfquery name="rsParam" datasource="#session.Fondos.dsn#">
		SELECT CJP02IMP,CJP02ORD FROM CJP002
		where CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#">
	</cfquery>

	<cfif modo eq "ALTA">
		<cfset mododet = "ALTA">
	<cfelseif isdefined("Form.Cambiodet")>
		<cfset mododet="CAMBIO">
	<cfelse>
		<cfif not isdefined("Form.mododet") and not isdefined("url.mododet")>
			<cfset mododet = "ALTA">
		<cfelse>
			<cfif isdefined("Form.mododet") and not isdefined("url.mododet")>
				<cfset mododet = "#Form.mododet#">
			<cfelseif not isdefined("Form.mododet") and isdefined("url.mododet")>
				<cfset mododet = "#url.mododet#">
			<cfelseif isdefined("Form.mododet") and isdefined("url.mododet")>
				<cfset mododet = "#Form.mododet#">
			</cfif>	
		</cfif>
	</cfif>
	<!---*********************************--->
	<cfif isdefined("url.CJX19REL") and len(trim(url.CJX19REL)) gt 0>
		<cfset  Form.CJX19REL = url.CJX19REL >
	</cfif>
	<cfif isdefined("url.CJX20NUM") and len(trim(url.CJX20NUM)) gt 0>
		<cfset  Form.CJX20NUM = url.CJX20NUM >
	</cfif>
	<!---********************************* --->
	<cfif mododet neq "ALTA">
		<cfif isdefined("url.CJX21LIN") and len(trim(url.CJX21LIN)) gt 0>
			<cfset  Form.CJX21LIN = url.CJX21LIN >
		</cfif>	
		<!---************************************************** --->
		<!---**Carga datos en modo cambio del detalle        ** --->
		<!---************************************************** --->
		<cfquery name="rsTpoFec" datasource="#session.Fondos.dsn#">
			select CJM08NOM from CJM008  WHERE CJM08TIP = 61
		</cfquery>		
		
		<cfquery datasource="#session.Fondos.dsn#"  name="TraeSqlDet" >	
			select
			CJX21LIN,  	CJX21TIP,	convert(varchar(20),CJX21MDU,1) CJX21MDU
			,CJX21IIN,	CJX21DSC,	convert(varchar(20),CJX21CAN,1) CJX21CAN,	CJX21PRE,	CJX21PDS
			,CJX21MDS,	CJX21MNT,	CJX21IGA,	CJX21ICF,	CJM16COD
			,CGE1COD,	CGE5COD,	PR1COD,		PRT7IDE,	CP6RUB
			,CP7SUB,	CJM12ID,	CJM13ID,	CJM07COD,	I92COD
			,I06COD,	CGM1ID,		CGM1IM,		CGM1CD,		timestamp
			FROM CJX021 
			where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
			and   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX20NUM#" >
			and   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX21LIN#" >
		</cfquery> 
		<cfset tsdet = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSqlDet.timestamp#" returnvariable="tsdet">
		</cfinvoke>		
		<cfquery datasource="#session.Fondos.dsn#"  name="TraeSqlDet2" >	
			select CJX22INF,timestamp
			FROM CJX022 
			where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
			and   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX20NUM#" >
			and   CJX21LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX21LIN#" >
		</cfquery> 	
			

		<cfset tsdet2 = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSqlDet2.timestamp#" returnvariable="tsdet2">
		</cfinvoke>		
	</cfif>
	<!---************************* --->
	<!---**crear una variable   ** --->
	<!---************************* --->
	<cfset regresar = "../MenuFondos.cfm">
	<!---*********************** --->
	<!---** AREA DE CONSULTAS  ** --->
	<!---************************ --->
	<cfquery name="rsSEG" datasource="#session.Fondos.dsn#">
		SELECT convert(char(5), a.CGE5COD) CGE5COD,b.CGE5DES 
		FROM CJM011 a,CGE005 b 
		WHERE a.CJM00COD= <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#"> 
		and a.CGE5COD=b.CGE5COD 
		and a.CGE1COD = b.CGE1COD
	</cfquery>
		
	<cfif modo neq "ALTA" and mododet neq "ALTA">
		<cfquery name="rsOrd" datasource="#session.Fondos.dsn#">
			SELECT CJM16COD,CJM16DES 
			FROM CJM016 
			WHERE CJM16CIE <> 1 
			AND CJM16COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSqlDet.CJM16COD#">
			AND <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.I04COD#">  between CJM16ING and CJM16FIG
			
		</cfquery>	
	</cfif>
    <cfif mododet eq "ALTA">
		<cfquery name="rsOrd2" datasource="#session.Fondos.dsn#">
			SELECT CJM16COD,CJM16DES 
			FROM CJM016 
			WHERE CJM16CIE <> 1 
			AND CJM16COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsParam.CJP02ORD#">
		</cfquery>	
	
	 </cfif>
	<cfquery name="rsIMP" datasource="#session.Fondos.dsn#">
		SELECT I92COD,I92DES FROM I92ARC
	</cfquery>
	
	<cfquery name="rsGRUPO" datasource="#session.Fondos.dsn#">
		SELECT CJM12ID LLAVE,CJM12DES DES FROM CJM012 
		WHERE CJM12EST=0
	</cfquery>
	
	<cfquery name="rsSG" datasource="#session.Fondos.dsn#">
		select CJM12ID,CJM13ID LLAVE,CJM13DES DES,CP6RUB,CP7SUB, isnull(CJM13CTP,'') CJM13CTP,ltrim(rtrim(CJM07COD)) CJM07COD from CJM013 
		where CJM13EST=0
		order by CJM12ID,CJM13ID
	</cfquery>
	<cfquery name="rsPER" datasource="#session.Fondos.dsn#">
		select  isnull(CJ1PER ,0) CJ1PER
		from  	CJX019 
		where 	CJX19REL  = <cfqueryparam  cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
	</cfquery>

	<cfset caracter="%">
	
	<cfif rsPER.recordCount EQ 0>
		<cfset LvarCJ1PER = session.Fondos.Anno>
	<cfelse>
		<cfset LvarCJ1PER = rsPER.CJ1PER>
	</cfif>
	<cfquery name="rsCTA" datasource="#session.Fondos.dsn#">
		select distinct a.PR1COD LLAVE,a.PR1NOM DES,PRT7IDE,b.CP6RUB,b.CP7SUB,PR1CTP,
		CGM1ID,CGM1IM,CGM1CD,b.CGE5COD 
		from PRT001 b, PRM001 a 
		where b.PERCOD = <cfqueryparam  cfsqltype="cf_sql_integer" value="#LvarCJ1PER#">
		and b.PRT22SUB = 1 
		and a.PR1COD = b.PR1COD
		and PR1CTP like <cfqueryparam  cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo##caracter#"> 
		order by b.CP6RUB,b.CP7SUB,PR1CTP,a.PR1COD
	</cfquery>

	<cfquery name="rsPROY" datasource="#session.Fondos.dsn#">
		select PRT7IDE LLAVE, PRT7DESC DES,PR1COD
		from PRT007  
		where PERCOD = <cfqueryparam  cfsqltype="cf_sql_integer" value="#LvarCJ1PER#">
		and PRT22SUB = 1
		order by PR1COD
	</cfquery>


	<!---*********************** --->
	<!---** AREA DE PINTADO    ** --->
	<!---************************ --->
	
	<table width="100%" border="0" >
		<tr>
			<td width="50%"  align="left" >
			<!---********************************************************************************* --->
			<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
			<!---********************************************************************************* --->
				<!---*********************** --->
				<!---** AREA DE HIDDEN    ** --->
				<!---*********************** --->
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CP6RUB" VALUE="<cfif mododet neq "ALTA">#TraeSqlDet.CP6RUB#</cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CP7SUB" VALUE="<cfif mododet neq "ALTA">#TraeSqlDet.CP7SUB#</cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CGE1COD" VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CGE1COD#</cfoutput><cfelse><cfoutput>#session.Fondos.Empresa#</cfoutput></cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJM07COD" VALUE="">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21PRE" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21PDS" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21MDS" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21MNT" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21IGA" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21ICF" VALUE="0">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="I06COD"   VALUE="">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CGM1ID"   VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CGM1ID#</cfoutput></cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CGM1IM"  VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CGM1IM#</cfoutput></cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CGM1CD"   VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CGM1CD#</cfoutput></cfif>">
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="CJX21TIP" VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CJX21TIP#</cfoutput><cfelse>D</cfif>">

				<cfoutput>			  
				<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="PERCOD" VALUE="#LvarCJ1PER#">
				<!---*********************** --->
				<!---** AREA DE TABLA     ** --->
				<!---*********************** --->
				  <table width="100%" border="0" >
					<!---********************************************************* --->
					<tr>
					  <td width="40%"  ><p><strong>Gastos:</strong></p> </td>
 					  <td >
					  	<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="GASTOS" 
							VALUE="<cfoutput>#GASTOS#</cfoutput>" 
							size="17"  
							style="border: medium none; text-align:left; size:auto;"
							tabindex="2"
						>						  
					  </td>					  
					  <td width="19%" ><p><strong>Anticipos:</strong></p></td>
					  <td width="21%" >
					  	<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="ANTICIPOS" 
							VALUE="<cfoutput>#ANTICIPOS#</cfoutput>" 
							size="17"  
							style="border: medium none; text-align:left; size:auto;"
							tabindex="2"
						>  
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td ><p><strong>Diferencia:</strong></p></td>
					  <td >
					  	<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="DIFERENCIA" 
							VALUE="<cfoutput>#DIFERENCIA#</cfoutput>" 
							size="17"  
							style="border: medium none; text-align:left; size:auto;"
							tabindex="2"
						>							  
					  </td>
					  <td width="19%" ><p><strong>Digitado:</strong></p></td>
					  <td width="21%" >
					  	<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="DIGITADO" 
							VALUE="<cfoutput>#DIGITADO#</cfoutput>" 
							size="17"  
							style="border: medium none; text-align:left; size:auto;"
							tabindex="2"
						>					  
					  </td>
					</tr>
					<!---********************************************************* --->
					<!--- <tr>
					  <td colspan="4"><hr></td>
					</tr> --->
					<!---********************************************************* --->
					 <cfif mododet neq "ALTA">
						  <tr>
							<td ><strong>Línea:</strong></td>
							<td colspan="4" >	
								<INPUT 	TYPE="textbox" 
										NAME="CJX21LIN" 
										VALUE="#TraeSqlDet.CJX21LIN#" 
										SIZE="20" 
										DISABLED 
										MAXLENGTH="11" 
										ONBLUR="" 
										ONFOCUS="this.select(); " 
										ONKEYUP="" 
										style="border: medium none; text-align:left; size:auto;"
										tabindex="2"
								>
							</td>
						  </tr>			
					 <cfelse>
					  	<input type="hidden" style="visibility:hidden"  name="CJX21LIN" value="" DISABLED >
					  </cfif>		
					<!---********************************************************* --->
					<tr>
					  <td><strong>Segmento :</strong></td>
					  <td width="20%"><select name="CGE5COD" tabindex="2"
  					  	  onChange="AgregarComboGR(document.form1.CJM12ID,document.form1.CGE5COD.value)">
						  <cfloop query="rsSEG">
							<option value="#trim(CGE5COD)#">#CGE5DES#</option>
						  </cfloop>
						</select>
					  </td>
						<!---********************************************************* --->
						<!---*********            AREA DEL DETALLE 2         ********* --->
						<!---********************************************************* --->
						<td rowspan="9"  colspan="2"valign="top">
							<cfinclude template="cjc_formPrincipalGastoDet2.cfm">
						</td>
						<cfif mododet neq "ALTA">
							<cfset arreglo = listtoarray(TraeSqlDet2.CJX22INF,"¶")>							
							<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
								<cfset arreglo2 = listtoarray(arreglo[i],"=")>
								<script language="JavaScript1.2" type="text/javascript">
									var id   	="<cfoutput>#Trim(arreglo2[1])#</cfoutput>"
									var valor   =""	
									var fecha   =""	
									 <cfloop query="rsTpoFec">
										if ('#Trim(rsTpoFec.CJM08NOM)#'=='#Trim(arreglo2[1])#'){
											 fecha   = "#Trim(arreglo2[2])#"
											 valor  = fecha.substring(6,8) + "/"+fecha.substring(4,6) + "/"+ fecha.substring(0,4)
										}
										else{
											 valor   ="#arreglo2[2]#"
										}
									</cfloop> 

									document.getElementById(id).value = valor
								</script> 
							</cfloop>
						</cfif>						
						<!---********************************************************* --->
						<!---*********        FIN AREA DEL DETALLE 2         ********* --->
						<!---********************************************************* --->
						
					</tr>

					<!---********************************************************* --->
					<tr>
					  <td><strong>Grupo :</strong></td>
					  <td width="20%">
						<select name="CJM12ID" tabindex="2"
							onChange="AgregarComboSG(document.form1.CJM13ID,document.form1.CJM12ID.value);">
						  	<cfloop query="rsGRUPO">
								<option value="#LLAVE#" <cfif  mododet NEQ "ALTA" and #LLAVE# EQ TraeSqlDet.CJM12ID>selected</cfif>>#DES#</option>
						  	</cfloop>
						</select>
					  </td>
					</tr>

		
					<!---********************************************************* --->
					<tr>
					  <td><strong>Subgrupo :</strong></td>
					  <td width="20%">
					  		<select name="CJM13ID" tabindex="2"
								onChange="AgregarComboCTA(document.form1.PR1COD,document.form1.CJM13ID.value)">
							</select>
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td><strong>Cta. Presup.:</strong></td>
					  <td width="20%">
					  		<select name="PR1COD"  tabindex="2"
								onChange="AgregarComboPROY(document.form1.PRT7IDE,document.form1.PR1COD.value)">
							</select>
							<strong>Proyecto :</strong>
					  		<select name="PRT7IDE" tabindex="2">
							</select>
					  </td>
					</tr>
					<!---********************************************************* --->
					
					<tr>
					  <td ><strong>Cantidad :</strong></td>
					  <td  >
						<input 	type="textbox" 
										name="CJX21CAN" 
										VALUE="<cfif mododet neq "ALTA">#TraeSqlDet.CJX21CAN#<cfelse>1.00</cfif>" 
										size="20" 
										maxlength="15" 
										ONBLUR="javascript: fm(this,2);" 
										ONFOCUS="javascript: this.value=qf(this); this.select(); " 
										ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
										tabindex="2"
								>
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td ><strong>Mto. Digitado :</strong></td>
					  <td >
						<input 	type="textbox" 
										name="CJX21MDU" 
										VALUE="<cfif mododet neq "ALTA">#TraeSqlDet.CJX21MDU#<cfelse>0.00</cfif>"  
										size="20" 
										maxlength="15" 
										ONBLUR="javascript: fm(this,2);" 
										ONFOCUS="javascript: this.value=qf(this); this.select(); " 
										ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
										tabindex="2"
								>
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td><strong>Imp. Incluido :</strong></td>
					  <td width="20%"><select name="CJX21IIN" onChange="" tabindex="2">
						  <option value="S" <cfif  mododet NEQ "ALTA" and "S" EQ TraeSqlDet.CJX21IIN>selected</cfif> >Si</option>
						  <option value="N" <cfif  mododet NEQ "ALTA" and "N" EQ TraeSqlDet.CJX21IIN>selected</cfif> >No</option>
						</select>
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td><strong>Grupo Imp. :</strong></td>
					  <td width="20%"><select name="I92COD" onChange="" tabindex="2">
						  <cfloop query="rsIMP">
							<option  value="#I92COD#" <cfif  mododet NEQ 'ALTA' and #I92COD# EQ #TraeSqlDet.I92COD#> selected <cfelseif mododet EQ 'ALTA' and #rtrim(ltrim(I92COD))# EQ #rtrim(ltrim(rsParam.CJP02IMP))#>selected</cfif>>#I92DES#</option>
						  </cfloop>
						</select>
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  
					  <td ><strong>Descripción :</strong></td>
					  <td colspan="4" >
						<textarea name="CJX21DSC" 
								rows="2" 
								cols="20" 
								onFocus="this.select();" 
								onBlur="" 
								onKeyUp=""
								tabindex="2"><cfif mododet neq "ALTA">#trim(TraeSqlDet.CJX21DSC)#</cfif></textarea>
						
					  </td>
					</tr>
					<!---********************************************************* --->
					<tr>
					  <td ><strong>Ord. Servicio :</strong></td>
					  <td colspan="4">
						<cfif mododet neq 'ALTA' >
							<cfif len(trim(#TraeSqlDet.CJM16COD#)) gt 0>
							  <cf_cjcConlis 	
												size		="30"  
												tabindex    ="2"
												name 		="CJM16COD" 
												desc 		="CJM16DES" 
												cjcconlist 	="cjc_traeOrd"
												query       ="#rsOrd#"
												form   		="form1"
												frame		="CJM16COD_FRM"
												filtro      ="""+document.form1.DEPCOD.value+"""
										>						
							<cfelse>
								  <cf_cjcConlis 
								  				tabindex    ="2"	
												size		="30"  
												name 		="CJM16COD" 
												desc 		="CJM16DES"
												frame		="CJM16COD_FRM" 
												cjcconlist 	="cjc_traeOrd"
												form   		="form1"
												filtro      ="""+document.form1.DEPCOD.value+"""
										>
							</cfif>
						<cfelse>
						  <cf_cjcConlis 	
											size		="30"  
											tabindex    ="2"
											name 		="CJM16COD" 
											desc 		="CJM16DES" 
											cjcconlist 	="cjc_traeOrd"
											frame		="CJM16COD_FRM"
											form   		="form1"
											query       ="#rsOrd2#" 
											filtro      ="""+document.form1.DEPCOD.value+"""
									>
						</cfif>
					  </td>
					</tr>
					<tr>
						<cfinclude template="cajanegra/cajanegra.cfm">
					</tr>
					<!---********************************************************* --->
					<tr>
						<td></td>
						<td colspan="4" >	
								<INPUT 	TYPE="textbox" 
										NAME="DESCUENTA" 
										VALUE="" 
										SIZE="50" 
										DISABLED 
										MAXLENGTH="50" 
										ONBLUR="" 
										ONFOCUS="this.select(); " 
										ONKEYUP="" 
										style="border: medium none; text-align:left; size:auto;"
										tabindex="2"
								>
							</td>
					</tr>
				  </table>
				</cfoutput>
			<!---********************************************************************************* --->
			<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
			<!---********************************************************************************* --->
			</td>
		</tr>
		<!---********************************************************* --->
		<cfif mododet eq "ALTA">
		</cfif>	
	</table>
	<input 	name="timestampdet" 
			type="hidden" 
			id="timestampdet" 
			style="visibility:hidden" 
			value="<cfif mododet NEQ "ALTA" ><cfoutput>#tsdet#</cfoutput></cfif>">			
	<input 	name="timestampdet2" 
			type="hidden" 
			id="timestampdet2" 
			style="visibility:hidden" 
			value="<cfif mododet NEQ "ALTA" ><cfoutput>#tsdet2#</cfoutput></cfif>">						
	<input type="hidden" style="visibility:hidden" name="error" value="">
	<input type="hidden" style="visibility:hidden" name="errorFlag" value="0">
	
</cfif>

