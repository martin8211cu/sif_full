
<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0 >
	<cfset  form.modo = url.modo >
</cfif>
<!---********************************* --->
<!---** para entrar en modo cambio  ** --->
<!---********************************* --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<!---********************************* --->
<cfquery name="rsTpoAnt" datasource="#session.Fondos.dsn#">
		select   
		  'CMONTO' = isnull((select convert(varchar(20),sum(CJX23MON),1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'C' AND CJX23TIP ='T'
			 ),'0.00'),
		'CCANT' = isnull((select convert(varchar(20),count(1),1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'C' AND CJX23TIP ='T'
			 ),'0.00'),
		'DMONTO' = isnull((select convert(varchar(20),sum(CJX23MON)*-1,1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'D' AND CJX23TIP ='T'
			 ),'0.00'),
		'DCANT' = isnull((select convert(varchar(20),count(1),1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'D' AND CJX23TIP ='T'
			 ),'0.00'),
		'RMONTO' = isnull((select convert(varchar(20),sum(CJX23MON),1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'R' AND CJX23TIP ='T'
			 ),'0.00'),
		'RCANT' = isnull((select convert(varchar(20),count(1),1)
			  from CJX023 B
			  where A.CJX19REL = B.CJX19REL
			 AND CJX23TTR = 'R' AND CJX23TIP ='T'
			 ),'0.00')
		from CJX019 A
		where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
		and A.CJX19EST = 'D'
</cfquery>
<cfif rsTpoAnt.recordcount gt 0>
	<cfset CMONTO   = "#rsTpoAnt.CMONTO#">
	<cfset CCANT 	= "#rsTpoAnt.CCANT#">
	<cfset DMONTO   = "#rsTpoAnt.DMONTO#">
	<cfset DCANT    = "#rsTpoAnt.DCANT#">
	<cfset RMONTO   = "#rsTpoAnt.RMONTO#">
	<cfset RCANT    = "#rsTpoAnt.RCANT#">
<cfelse>
	<cfset CMONTO   = "0.00">
	<cfset CCANT 	= "0">
	<cfset DMONTO   = "0.00">
	<cfset DCANT    = "0">
	<cfset RMONTO   = "0.00">
	<cfset RCANT    = "0">
</cfif>	
<cfif modo neq "ALTA">
<!---************* CAmbio ********** --->
<!---********************************************************* --->
<!---** para verificar el valor de la llave y coloca en var ** --->
<!---********************************************************* --->
	<cfif isdefined("url.CJX23CON") and len(trim(url.CJX23CON)) gt 0>
		<cfset  form.CJX23CON = url.CJX23CON >
	</cfif>
<!---************************ --->
<!---** TOTALES DE RELACION ** --->
<!---************************ --->
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
	select convert(varchar(20),isnull(sum(CJX23MON),0),1) CJX23MON
	from CJX023
	where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX19REL#">
</cfquery>

<cfset ANTICIPOS = "#rsAnticipos.CJX23MON#">
<!---********************************************************* --->
<!---**aqui se definen las diferentes consultas SQL         ** --->
<!---********************************************************* --->
	<cfquery datasource="#session.Fondos.dsn#"  name="TraeSql" >	
		select CJX19REL,CJX23CON, CJX23TIP,convert(varchar,CJX23MON,1)CJX23MON,TS1COD,CJX23AUT,
		TR01NUT,CJX23CHK ,CP9COD,EMPCOD,CJX23TTR,CJX5IDE,convert(varchar(10),CJX23FEC,103) CJX23FEC,timestamp
		from  CJX023
		where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
		and   CJX23CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX23CON#" >
	</cfquery>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSql.timestamp#" returnvariable="ts">
	</cfinvoke>
	
	<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
		SELECT EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE FROM PLM001 
		where  EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.EMPCOD#" >
	</cfquery>
	
	<cfquery name="rsAutorizador" datasource="#session.Fondos.dsn#">
			select CJM005.CP9COD,CP9DES 
			from CJM005,CPM009,CJM001 
			where CJM005.CP9COD = CPM009.CP9COD 
			AND CJM005.CJM00COD = CJM001.CJM00COD 
			AND CJM005.CJM05EST = 'A' 
			AND CJM001.CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
			and CJM005.CP9COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.CP9COD#">
	</cfquery>
	<cfset SALDO = "">
	<cfif len(trim(TraeSql.CJX5IDE)) gt 0>
		<cfquery name="RSsaldo" datasource="#session.Fondos.dsn#"> 
			SELECT SALDO = convert(varchar(14),CJX5MON-isnull(CJX5MSP,0.00)-CJX5MAP,1) 
			FROM CJX005
			WHERE CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
			AND CJX5IDE   = <cfqueryparam cfsqltype="cf_sql_integer" value="#TraeSql.CJX5IDE#" >
			AND CJX5EST='P'  order by CJX5IDE
		</cfquery>	
		<cfset SALDO = #RSsaldo.SALDO#>
	</cfif>

	
</cfif>
<!---********************************************************* --->
<!---** inicializa la variable x del from en un valor       ** --->
<!---** en caso de que no este definida aun se usa para     ** --->
<!---** el combo										    ** --->
<!---********************************************************* --->


<!---************************* --->
<!---**crear una variable   ** --->
<!---************************* --->
<cfset regresar = "../MenuFondos.cfm">
 <!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<cfset CEROS = "0">
<cfquery name="rsCeros" datasource="#session.Fondos.dsn#">
	select CJPCAN from CJP001
</cfquery>
<cfset CEROS = #rsCeros.CJPCAN#>
<cfquery name="rsRelacion" datasource="#session.Fondos.dsn#">
	select   CJX19REL,'REL-'+ convert(varchar,CJX19REL) CJX19DES from CJX019 
	WHERE  CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
	AND CJX19EST = 'D'
</cfquery>

<cfquery name="rsCondicion" datasource="#session.Fondos.dsn#">
	SELECT SUBSTRING(CJPGU,4,1) CJPGU ,
	(case when SUBSTRING(CJPGU,1,2) = '11' then 'A'  when SUBSTRING(CJPGU,1,2) = '10' then 'C'   when SUBSTRING(CJPGU,1,2) = '01' then 'E' else 'N' end) TIPO
	FROM CJM001 
	WHERE  CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
</cfquery>
<cfset Condicion = #rsCondicion.CJPGU#>
<cfset TPO       = #rsCondicion.TIPO#>
<cfquery name="rsTpoTJ" datasource="#session.Fondos.dsn#">
	SELECT TS1COD,TS1DES FROM CPTSM1
</cfquery>

<cfquery name="rsTarjetas" datasource="#session.Fondos.dsn#">
		SELECT CJM014.TS1COD,CJM014.TR01NUT,CJM00COD,TR01NCO
		FROM CJM014,CATR01 
		WHERE   CJM014.TS1COD = CATR01.TS1COD 
		AND 	CJM014.TR01NUT = CATR01.TR01NUT
		AND 	CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#">
</cfquery>
<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>

<table width="100%" border="0" >
	<td width="50%"  align="left" >
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
		<form action="../operacion/cjc_SqlAnticipos.cfm" method="post" name="form1" onSubmit="javascript:finalizar();">
			<cfoutput>
			<table width="100%" border="0">
				<!--- ******************************************************************************************* --->
				<tr>
					<td width="15%"><strong>SubFondo:</strong></td>
					<td width="25%">#session.Fondos.Caja#</td>
					<td width="25%"><strong>Usuario :</strong></td>
					<td width="25%">#session.usuario#</td>
				</tr>
				<!--- ******************************************************************************************* --->
				<tr>
					<td><strong>Moneda :</strong></td>
					<td>#session.Fondos.MonedaDes#</td>
					<td><strong>No. :</strong></td>
					<td width="56%">
						<select name="CJX19REL" onChange="validaREL()">
							<option value="0">Nueva</option>
							<cfloop query="rsRelacion"> 
								<option value="#CJX19REL#" <cfif Form.CJX19REL EQ rsRelacion.CJX19REL>selected</cfif>>#CJX19DES#</option>
							</cfloop> 
							</select>
					</td>
				</tr>
				<!--- ******************************************************************************************* --->
				<!---	
				<tr>
					<td colspan="4"><hr></td>
				</tr>
				--->					 
				<!--- ******************************************************************************************* --->
				<cfif modo neq "ALTA">
					<tr>
						<td ><strong>Consecutivo:</strong></td>
						<td colspan="4" >	
							<INPUT 	TYPE="textbox" 
								NAME="CJX23CON" 
								VALUE="#TraeSql.CJX23CON#" 
								SIZE="20" 
								DISABLED 
								MAXLENGTH="11" 
								ONBLUR="" 
								ONFOCUS="this.select(); " 
								ONKEYUP="" 
								style="border: medium none; text-align:left; size:auto;"
							>							
						</td>
					</tr>			
				<cfelse>
					<input type="hidden" name="CJX23CON" value="" DISABLED >
				</cfif>		
				<!--- ******************************************************************************************* --->
				<tr>
					<td ><strong>Tipo de pago:</strong></td>
					<cfif Condicion neq "1">
						<td>
							<cfif TPO eq "A">
								<SELECT  <cfif modo NEQ 'ALTA'>disabled</cfif> NAME="CJX23TIP" onchange="validaTIP()">
									<OPTION  VALUE="E" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "E" >selected</cfif>>EFECTIVO</OPTION>
									<OPTION  VALUE="C" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "C" >selected</cfif>>CHEQUE</OPTION>
									<OPTION  VALUE="V" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "V" >selected</cfif>>VALE</OPTION>
								</SELECT>
							<cfelseif TPO eq "C">
								<SELECT <cfif modo NEQ 'ALTA'>disabled</cfif> NAME="CJX23TIP" onchange="validaTIP()">
									<OPTION  VALUE="C" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "C" >selected</cfif>>CHEQUE</OPTION>
									<OPTION  VALUE="V" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "V" >selected</cfif>>VALE</OPTION>
								</SELECT>								
							<cfelse>
								<SELECT <cfif modo NEQ 'ALTA'>disabled</cfif> NAME="CJX23TIP" onchange="validaTIP()">
									<OPTION  VALUE="E" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "E" >selected</cfif>>EFECTIVO</OPTION>
									<OPTION  VALUE="V" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "V" >selected</cfif>>VALE</OPTION>
								</SELECT>
							</cfif>						  
						</td>
					<cfelse>
						<td>
							<SELECT <cfif modo NEQ 'ALTA'>disabled</cfif> NAME="CJX23TIP" onchange="validaTIP()">
								<OPTION  VALUE="T" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "T" >selected</cfif>>TARJETA</OPTION>
								<!--- <OPTION  VALUE="V" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TIP eq "V" >selected</cfif>>VALE</OPTION> --->
							</SELECT>				
						</td>		
					</cfif>
				</tr>
				<!--- ******************************************************************************************* --->
				<!---
				<tr>
					<td ><strong>Monto:</strong></td>
					<td colspan="4">	
						<INPUT 	TYPE="textbox" 
							NAME="CJX23MON" 
							VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23MON#</cfif>" 
							SIZE="20" 
							MAXLENGTH="15"  
							ONBLUR="javascript: fm(this,2);" 
							ONFOCUS="javascript: this.value=qf(this); this.select(); " 
							ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
						>
					</td>
				</tr>		
				--->
				<!--- ******************************************************************************************* --->
				<tr>
					<td>
						<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="VALE" 
							ID  ="VALE" 
							VALUE="No. Vale:" 
							size="15"  
							style="border: medium none; text-align:left; size:auto; font-weight:bold; font-weight:bold; visibility:hidden;"
						>					  
					</td>
					<td>	
						<INPUT 	TYPE="textbox"  
								NAME="CJX5IDE" 
								ID  ="CJX5IDE"
								DISABLED 
								VALUE="<cfif modo neq "ALTA">#TraeSql.CJX5IDE#</cfif>" 
								SIZE="20" 
								MAXLENGTH="15" 
								ONBLUR="" 
								ONFOCUS="this.select(); " 
								ONKEYUP=""  
								style="visibility:hidden; border: medium none; text-align:left; size:auto;"
						>
					</td>
					<td>
						<INPUT  tabindex="-1" 
							ONFOCUS="this.blur();" 
							NAME="DISPVALE" 
							ID  ="DISPVALE" 
							VALUE="Disponible en vale:" 
							size="20"  
							style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:hidden;"
						>					  
					</td>
					<td>	
						<INPUT 	TYPE="textbox"  
							NAME="MONTVALE" 
							ID  ="MONTVALE"
							DISABLED 
							VALUE="<cfif modo neq "ALTA">#SALDO#</cfif>" 
							SIZE="20" 
							MAXLENGTH="15" 
							ONBLUR="javascript: fm(this,2);" 
							ONFOCUS="javascript: this.value=qf(this); this.select(); " 
							ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
							style="visibility:hidden; border: medium none; text-align:left; size:auto;"
						>
					</td>
				</tr>		
				<!--- ******************************************************************************************* --->
				<cfif Condicion neq "1">
					<cfif TPO eq "A">
						<!--- ******************************** --->
						<!---** AREA DE EFECTIVO Y CHEQUES  ** --->
						<!--- ******************************** --->
						<!--- ********************************************************* --->		
						<tr>
							<td ><strong>Monto:</strong></td>
							<td colspan="4">	
								<INPUT 	TYPE="textbox" 
									NAME="CJX23MON" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23MON#</cfif>" 
									SIZE="20" 
									MAXLENGTH="15"  
									ONBLUR="javascript: fm(this,2);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
								>
							</td>
						</tr>		
						<!--- ********************************************************* --->			
						<tr>
							<td>
								<input type="hidden" name="CJX23FEC" value=""  >						  	  
							</td>
						</tr> 					  
						<!--- ********************************************************* --->			
						<tr>
							<td>
								<INPUT  tabindex="-1" 
									ONFOCUS="this.blur();" 
									NAME="ETIQUETA" 
									ID  ="ETIQUETA" 
									VALUE="No. Cheque:" 
									size="15"  
									style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:hidden;"
								>							   
							</td>
							<td colspan="4">	
								<INPUT 	TYPE="textbox"  
										NAME="CJX23CHK" 
										ID  ="CJX23CHK"
										VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23CHK#</cfif>" 
										SIZE="20" 
										MAXLENGTH="15" 
										ONBLUR="" 
										ONFOCUS="this.select(); " 
										ONKEYUP=""  
										style="visibility:hidden;"
								>
							</td>
						</tr>		
					<cfelseif TPO eq "C">
						<!--- ********************* --->
						<!--- ** AREA DE CHEQUES ** --->
						<!--- ********************* --->
						<!--- ********************************************************* --->		
						<tr>
							<td ><strong>Monto:</strong></td>
							<td colspan="4">	
								<INPUT 	TYPE="textbox" 
									NAME="CJX23MON" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23MON#</cfif>" 
									SIZE="20" 
									MAXLENGTH="15"  
									ONBLUR="javascript: fm(this,2);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
								>							  
							</td>
						</tr>		
						<!--- ********************************************************* --->									
						<tr>
							<td>
								<input type="hidden" name="CJX23FEC" value=""  >						  	  
							</td>
						</tr>		
						<!--- ********************************************************* --->						 
						<tr>
							<td>
								<INPUT  tabindex="-1" 
									ONFOCUS="this.blur();" 
									NAME="ETIQUETA" 
									ID  ="ETIQUETA" 
									VALUE="No. Cheque:" 
									size="15"  
									style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:hidden;"
								>							   
							</td>
							<td colspan="4">	
								<INPUT 	TYPE="textbox"  
									NAME="CJX23CHK" 
									ID  ="CJX23CHK"
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23CHK#</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select(); " 
									ONKEYUP=""  
									style="visibility:hidden;"
								>
							</td>
						</tr>		
					<cfelseif TPO eq "E">
						<!---********************************************************* --->	
						<tr>
							<td ><strong>Monto:</strong></td>
							<td colspan="4">
								<INPUT 	TYPE="textbox" 
									NAME="CJX23MON" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23MON#</cfif>" 
									SIZE="20" 
									MAXLENGTH="15"  
									ONBLUR="javascript: fm(this,2);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
								>
							</td>
						</tr>		
						<!--- ********************************************************* --->								
						<INPUT TYPE="HIDDEN" NAME="CJX23CHK" VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23CHK#</cfif>">
						<input type="hidden" name="CJX23FEC" value=""  >
					</cfif>
				<cfelse>
					<!--- *********************** --->
					<!---** AREA DE TARJETAS   ** --->
					<!---************************ --->
					<INPUT TYPE="HIDDEN" NAME="CP9COD" VALUE="<cfif modo neq "ALTA">#TraeSql.CP9COD#</cfif>">
					<!--- ********************************************************* --->
					<!---
					<tr>
						<td>
							<INPUT  tabindex="-1" 
								ONFOCUS="this.blur();" 
								NAME="AUT" 
								ID  ="AUT" 
								VALUE="Autorizador:" 
								size="15"  
								style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
							>					  
						</td>										
						<td colspan="4">	
								<cfif modo neq 'ALTA' >
									<cf_cjcConlis 	
											size		="30"  
											name 		="CP9COD" 
											desc 		="CP9DES" 
											cjcConlisT 	="cjc_traeAut"
											query       ="#rsAutorizador#"
											form   		="form1"
									>
								<cfelse>	
									<cf_cjcConlis 	
											size		="30"  
											name 		="CP9COD" 
											desc 		="CP9DES" 
											cjcConlisT 	="cjc_traeAut"
											form   		="form1"
									>
								</cfif>	
							</td>
						  </tr>
					  	  ********************************************************* --->			
						  <tr>
							<td>
								<INPUT  tabindex="-1" 
									ONFOCUS="this.blur();" 
									NAME="EMP" 
									ID  ="EMP" 
									VALUE="Empleado:" 
									size="15"  
									style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
								>					  
							</td>							
							<td colspan="4">	
								<cfif modo neq 'ALTA' >
									<cf_cjcConlis 	
											size		="30"  
											name 		="EMPCED" 
											desc 		="NOMBRE" 
											id			="EMPCOD" 
											<!--- name2		="TS1COD" --->
											desc2		="TR01NUT"
											cjcConlisT 	="cjc_traeEmp2"
											query       ="#rsEmpleado#"
											form   		="form1"
									>			
								<cfelse>
									<cf_cjcConlis 	
											size		="30"  
											name 		="EMPCED" 
											desc 		="NOMBRE" 
											id			="EMPCOD" 
											<!--- name2		="TS1COD" --->
											desc2		="TR01NUT"
											cjcConlisT 	="cjc_traeEmp2"
											form   		="form1"
									>
							  </cfif>
							</td>
						  </tr>	
						<!---********************************************************* --->	
						<tr>
							<td>
								<INPUT  tabindex="-1" 
									ONFOCUS="this.blur();" 
									NAME="TPOTAR" 
									ID  ="TPOTAR" 
									VALUE"Seleccione Voucher:" 
									size="15"  
									style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
								>					  
							</td>							
							<td>
								<select  id="TS1COD" style="visibility:" name="TS1COD">
								<cfloop query="rsTpoTJ"> 
								<option value="#trim(TS1COD)#" <cfif  modo NEQ "ALTA" and #TS1COD# EQ TraeSql.TS1COD>selected</cfif>>#TS1DES#</option>
								</cfloop> 
								</select>
							</td>						  
					    </tr>
						  <!---********************************************************* --->	
							  <tr>
								<td>
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="NUMTAR" 
										ID  ="NUMTAR" 
										VALUE="No. Tarjeta:" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>					  
								</td>										
								<td colspan="4">	
									<INPUT 	TYPE="textbox" 
											NAME="TR01NUT" 
											ID  ="TR01NUT"
											VALUE="<cfif modo neq "ALTA">#TraeSql.TR01NUT#</cfif>" 
											SIZE="20" 
											MAXLENGTH="20" 
											ONBLUR="CARGATJ()"
											ONFOCUS="this.select(); " 
											ONKEYUP="" 
											style="visibility:"
									>
								</td>
							</tr>
							<!--- ******************************************************************************* --->
							<tr>
								<td>
                                  <input  tabindex="-1" 
										onFocus="this.blur();" 
										name="INFO" 
										id  ="INFO" 
										value="Seleccione Voucher:" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>
								</td>
								<td colspan="4">
									<a id="VOUCHER_IMG" href="##" tabindex="-1" style="visibility:visible">
								 		<img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de selección vouchers" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: ConlisVoucher();'>
									</a>
								</td>
							</tr>	
							
							<!--- ******************************************************************************* --->
							<tr>
								<td>
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="AUTTAR" 
										ID  ="AUTTAR" 
										VALUE="No. Autorización:" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>					  
								</td>										
								<td colspan="4">	
									<INPUT 	TYPE="textbox"  
										NAME="CJX23AUT" 
										ID  ="CJX23AUT"
										VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23AUT#</cfif>" 
										SIZE= "20" 
										MAXLENGTH="20" 
										onChange= "llenar_string(this,#CEROS#,'0');TRAE_AUTO(this)"
										ONFOCUS="this.select(); " 
										ONKEYUP="" 
										style="visibility:"
									>
								</td>
							</tr>
							<!--- ******************************************************************************* --->
							<tr>
								<td><strong>Monto:</strong></td>
								<td colspan="4">	
									<INPUT 	TYPE="textbox" 
										NAME="CJX23MON" 
										VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23MON#</cfif>" 
										SIZE="20" 
										MAXLENGTH="15"  
										ONBLUR="javascript: fm(this,2);" 
										ONFOCUS="javascript: this.value=qf(this); this.select(); " 
										ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
									>
								</td>
							</tr>		
							<!--- ******************************************************************************* --->
							<tr>
								<cfif modo neq 'ALTA' >
									<cfset CJX23FEC = TraeSql.CJX23FEC >
								<cfelse>
									<cfset CJX23FEC = "" >
								</cfif>
								<td>
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="FECHA" 
										ID  ="FECHA" 
										VALUE="Fecha:" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>
								</td>	
								<td colspan="4" valign="baseline" nowrap>	
									<cf_CJCcalendario  name="CJX23FEC" form="form1"  value="#CJX23FEC#"> 	
								</td>
							</tr>
							<!--- ******************************************************************************* --->
						  <TR>
						      <td ></td>
							  <TD colspan="4">
                                <input type="radio" style="visibility:" name="CJX23TTR" id="CJX23TTR1" value="C" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TTR eq "C" >checked <cfelse>checked </cfif> > Compra Directa
                                <INPUT type="radio" style="visibility:" name="CJX23TTR" id="CJX23TTR2" value="D" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TTR eq "D" >checked </cfif> > Devoluci&oacute;n &nbsp;&nbsp;&nbsp;
								<INPUT type="radio" style="visibility:" name="CJX23TTR" id="CJX23TTR3" value="R" <cfif modo NEQ 'ALTA' and TraeSql.CJX23TTR eq "R" >checked </cfif> > Retiro
							</TD>
						</TR>			
					     <!---********************************************************* --->
						  <TR>
						      <td ><strong>Cantidad:</strong></td>
							  <TD colspan="4">
							       &nbsp;
								   &nbsp;
								   &nbsp;
								   <INPUT tabindex="-1" 
										onfocus="this.blur();" 
										name="CCANT" 
										id  ="CCANT" 
										value="#CCANT#" 
										size="10"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold;"
									>	 
									&nbsp;
									&nbsp;
									&nbsp;
									&nbsp;
									&nbsp;
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="DCANT" 
										ID  ="DCANT" 
										VALUE="#DCANT#" 
										size="10"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; "
									>
									&nbsp;
									&nbsp;
									&nbsp;
									&nbsp;
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="RCANT" 
										ID  ="RCANT" 
										VALUE="#RCANT#"
										size="10"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; "
									>													  
							  </TD>
						  </TR>		
						  <!---********************************************************* --->
						  <TR>
						      <td ><strong>Monto:</strong></td>
							  <TD colspan="4">
							       &nbsp;
								   &nbsp;
								   &nbsp;
								   <INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="CMONTO" 
										ID  ="CMONTO" 
										VALUE="#CMONTO#" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold;"
									>	 
									&nbsp;
									
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="DMONTO" 
										ID  ="DMONTO" 
										VALUE="#DMONTO#" 
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; "
									>
									&nbsp;
									<INPUT  tabindex="-1" 
										ONFOCUS="this.blur();" 
										NAME="RMONTO" 
										ID  ="RMONTO" 
										VALUE="#RMONTO#"
										size="15"  
										style="border: medium none; text-align:left; size:auto; font-weight:bold; "
									>													  
							  </TD>
						  </TR>					 
					  <!---********************************************************* --->	
					  </cfif>
					  <!---********************************************************* --->	
					  <tr>
						<td colspan="4">
						<cfinclude  template="../portlets/ABotones.cfm">
						</td>
					  </tr>
					  <!---********************************************************* --->
					</table>	
					<cfif Condicion neq "1">
					   	<!--- ******************************** --->
						<!---** AREA DE EFECTIVO Y CHEQUES  ** --->
					   	<!--- ******************************** --->
						<INPUT TYPE="HIDDEN" NAME="TS1COD" 		VALUE="<cfif modo neq "ALTA">#TraeSql.TS1COD#</cfif>">
						<INPUT TYPE="HIDDEN" NAME="TR01NUT" 	VALUE="<cfif modo neq "ALTA">#TraeSql.TR01NUT#</cfif>">
						<INPUT TYPE="HIDDEN" NAME="CP9COD" 		VALUE="<cfif modo neq "ALTA">#TraeSql.CP9COD#</cfif>">
						<INPUT TYPE="HIDDEN" NAME="EMPCOD" 		VALUE="<cfif modo neq "ALTA">#TraeSql.EMPCOD#</cfif>">
						<INPUT TYPE="HIDDEN" NAME="CJX23TTR" 	VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23TTR#</cfif>">
						<INPUT TYPE="HIDDEN" NAME="CJX23AUT" 	VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23AUT#</cfif>">
						<script language="JavaScript1.2" type="text/javascript">	
							
							
							function validaTIP(){ 
								<cfif TPO neq "E">
									var ETIQUETA  	= document.getElementById("ETIQUETA")
									var CJX23CHK  	= document.getElementById("CJX23CHK")
								</cfif>
								var VALE  		= document.getElementById("VALE")
								var CJX5IDE  	= document.getElementById("CJX5IDE")
								var DISPVALE  	= document.getElementById("DISPVALE")
								var MONTVALE  	= document.getElementById("MONTVALE")
								var LSTANT  	= document.getElementById("LSTANT")
								if (document.form1.CJX23TIP.value == "C"){
									<cfif TPO neq "E">
										ETIQUETA.style.visibility='visible'
										CJX23CHK.style.visibility='visible'
										objform1.CJX23CHK.required = true;
										objform1.CJX23CHK.description="Cheque";										
									</cfif>	

									objform1.CJX5IDE.required = false;
									VALE.style.visibility='hidden'
									CJX5IDE.style.visibility='hidden'
									DISPVALE.style.visibility='hidden'
									MONTVALE.style.visibility='hidden'
									LSTANT.style.display 	= "none"
								}
								else 
								if (document.form1.CJX23TIP.value == "V"){
									<cfif TPO neq "E">
										objform1.CJX23CHK.required = false;
										ETIQUETA.style.visibility='hidden'
										CJX23CHK.style.visibility='hidden'
									</cfif>	
									objform1.CJX5IDE.required = true;
									objform1.CJX5IDE.description="No. Vale";
									VALE.style.visibility='visible'
									CJX5IDE.style.visibility='visible'
									DISPVALE.style.visibility='visible'
									MONTVALE.style.visibility='visible'		
									<cfif modo neq "ALTA">
										LSTANT.style.display 	= "none"	
									<cfelse>
										LSTANT.style.display 	= ""
									</cfif>							
								}	
								else
								if (document.form1.CJX23TIP.value == "E"){
									<cfif TPO neq "E">
										ETIQUETA.style.visibility='hidden'
										CJX23CHK.style.visibility='hidden'
										objform1.CJX23CHK.required = false;
									</cfif>	
									
									objform1.CJX5IDE.required = false;
									VALE.style.visibility='hidden'
									CJX5IDE.style.visibility='hidden'
									DISPVALE.style.visibility='hidden'
									MONTVALE.style.visibility='hidden'		
									LSTANT.style.display 	= "none"								
								}	
								 
							}
						</script> 						
					<cfelse>
					   	<!--- *********************** --->
						<!---** AREA DE TARJETAS   ** --->
						<!---************************ --->					
						<INPUT TYPE="HIDDEN" NAME="CJX23CHK" 	VALUE="<cfif modo neq "ALTA">#TraeSql.CJX23CHK#</cfif>">
						<script language="JavaScript1.2" type="text/javascript">	
							function validaTIP(){ 
								var VALE  		= document.getElementById("VALE")
								var CJX5IDE  	= document.getElementById("CJX5IDE")
								var DISPVALE  	= document.getElementById("DISPVALE")
								var MONTVALE  	= document.getElementById("MONTVALE")
								var TS1COD  	= document.getElementById("TS1COD")
								var TR01NUT  	= document.getElementById("TR01NUT")
								//var CP9COD  	= document.getElementById("CP9COD")
								//var CP9CODIMG  	= document.getElementById("CP9CODIMG")
								//var CP9DES  	= document.getElementById("CP9DES")
								var EMPCED  	= document.getElementById("EMPCED")
								var EMPCEDIMG  	= document.getElementById("EMPCEDIMG")
								var NOMBRE  	= document.getElementById("NOMBRE")
								var CJX23TTR1  	= document.getElementById("CJX23TTR1")
								var CJX23TTR2  	= document.getElementById("CJX23TTR2")
								var CJX23TTR3  	= document.getElementById("CJX23TTR3")
								var TPOTAR  	= document.getElementById("TPOTAR")
								var NUMTAR  	= document.getElementById("NUMTAR")
								//var AUT  		= document.getElementById("AUT")
								var EMP  		= document.getElementById("EMP")
								//var CD  		= document.getElementById("CD")
								//var DV  		= document.getElementById("DV")
								//var RT  		= document.getElementById("RT")
								var AUTTAR  	= document.getElementById("AUTTAR")
								var CJX23AUT  	= document.getElementById("CJX23AUT")
								var LSTANT  	= document.getElementById("LSTANT")
								var FECHA   	= document.getElementById("FECHA")
								var CJX23FEC  	= document.getElementById("CJX23FEC")
								var CJX23FECIMG = document.getElementById("CJX23FECIMG")
								
								if (document.form1.CJX23TIP.value != "V"){
									objform1.CJX5IDE.required = false;
									/*
									objform1.CP9COD.required = true;
									objform1.CP9COD.description="Autorizador";
									*/
									objform1.EMPCED.required = true;
									objform1.EMPCED.description="Empleado";
									objform1.TR01NUT.required = true;
									objform1.TR01NUT.description="No. tarjeta";
									objform1.CJX23AUT.required = true;
									objform1.CJX23AUT.description="No. Autorización";
									objform1.CJX23FEC.required = true;
									objform1.CJX23FEC.description="Fecha";
									VALE.style.visibility='hidden'
									CJX5IDE.style.visibility='hidden'
									DISPVALE.style.visibility='hidden'
									MONTVALE.style.visibility='hidden'
									TS1COD.style.visibility='visible'
									TR01NUT.style.visibility='visible'
									//CP9COD.style.visibility='visible'
									//CP9DES.style.visibility='visible'
									EMPCED.style.visibility='visible'
									NOMBRE.style.visibility='visible'
									CJX23TTR1.style.visibility='visible'
									CJX23TTR2.style.visibility='visible'
									CJX23TTR3.style.visibility='visible' 
									EMPCEDIMG.style.visibility='visible' 
									//CP9CODIMG.style.visibility='visible' 
									TPOTAR.style.visibility='visible' 
									NUMTAR.style.visibility='visible' 
									//AUT.style.visibility='visible' 
									EMP.style.visibility='visible' 			
									//CD.style.visibility='visible' 			
									//DV.style.visibility='visible' 			
									//RT.style.visibility='visible'
									CJX23AUT.style.visibility='visible'
									AUTTAR.style.visibility='visible'
									FECHA.style.visibility='visible'
									CJX23FEC.style.visibility='visible'					
									CJX23FECIMG.style.visibility='visible'				
									LSTANT.style.display 	= "none" 			
								}
								else 
								if (document.form1.CJX23TIP.value == "V"){
									objform1.CJX5IDE.required = true;
									objform1.CJX5IDE.description="No. Vale";
									//objform1.CP9COD.required = false;
									objform1.EMPCED.required = false;
									objform1.TR01NUT.required = false;
									objform1.CJX23AUT.required = false;
									objform1.CJX23FEC.required = false;
									CJX5IDE.style.visibility='visible'
									DISPVALE.style.visibility='visible'
									MONTVALE.style.visibility='visible'	
									TS1COD.style.visibility='hidden'	
									CJX23AUT.style.visibility='hidden'
									//CP9COD.style.visibility='hidden'
									//CP9DES.style.visibility='hidden'
									EMPCED.style.visibility='hidden'
									NOMBRE.style.visibility='hidden'
									CJX23TTR1.style.visibility='hidden'
									CJX23TTR2.style.visibility='hidden'
									CJX23TTR3.style.visibility='hidden'
									EMPCEDIMG.style.visibility='hidden'
									//CP9CODIMG.style.visibility='hidden'
									TPOTAR.style.visibility='hidden'
									NUMTAR.style.visibility='hidden'
									//AUT.style.visibility='hidden' 
									EMP.style.visibility='hidden' 									
									//CD.style.visibility='hidden' 			
									//DV.style.visibility='hidden' 			
									//RT.style.visibility='hidden' 	
									TR01NUT.style.visibility='hidden'
									AUTTAR.style.visibility='hidden'
									FECHA.style.visibility='hidden'
									CJX23FEC.style.visibility='hidden'
									CJX23FECIMG.style.visibility='hidden'				
									<cfif modo neq "ALTA">
										LSTANT.style.display 	= "none"	
									<cfelse>
										LSTANT.style.display 	= ""
									</cfif>		
								}	
							}
						</script> 						
			  </cfif>
					<input 	name="timestamp" type="hidden" id="timestamp" value="<cfif modo NEQ "ALTA" ><cfoutput>#ts#</cfoutput></cfif>">					
					<input type="hidden" name="PERCOD" 		value="<cfoutput>#session.Fondos.Anno#</cfoutput>" DISABLED >
					<input type="hidden" name="MESCOD" 		value="<cfoutput>#session.Fondos.Mes#</cfoutput>" DISABLED >
					<input type="hidden" name="CJM00COD" 	value="<cfoutput>#session.Fondos.Fondo#</cfoutput>" DISABLED >
			</cfoutput>		
			<iframe id="FRAMEAUTO" name="FRAMEAUTO" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
		    </form>
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
		<td valign="top">
			<cfinclude template="../Utiles/listaAnticipos.cfm">
		</td>
	</tr>
	<tr>
		<td width="50%"  align="left" valign="top">
				<cfinvoke 
					component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJX023"/>
					<cfinvokeargument name="columnas" value="CJX19REL,CJX23CON,
					(case when CJX23TIP = 'C' then 'Cheque' 
						  when CJX23TIP = 'E' then 'Efectivo' 
						  when CJX23TIP = 'T' then  '['+CJX23TTR+'] TJ :' +TR01NUT+' AUT :'+CJX23AUT
						  when CJX23TIP = 'V' then 'Vale ['+convert(varchar,CJX5IDE)+']' end) CJX23TIP,
						  case when CJX23TTR = 'D' then CJX23MON * -1 else  CJX23MON end as CJX23MON"/>
					<cfinvokeargument name="desplegar" value="CJX23CON,CJX23TIP,CJX23MON"/>
					<cfinvokeargument name="etiquetas" value="Núm.,Tipo,Monto"/>
					<cfinvokeargument name="formatos" value="S,S,M"/>
					<cfinvokeargument name="filtro" value="CJX19REL =#Form.CJX19REL#"/>
					<cfinvokeargument name="align" value="left,left,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CJX19REL,CJX23CON"/>
					<cfinvokeargument name="irA" value="cjc_PrincipalAnticipos.cfm"/>
				</cfinvoke>		
		</td>
		<td>
		</td>
  	</tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");

	objform1.CJX23MON.required = true;
	objform1.CJX23MON.description="monto";	 
	
	function Monto_valida(){
		var Monto = new Number(this.value)	
		if ( Monto < 0){
			this.error = "El monto debe ser mayor a cero";
		}		
	}
	_addValidator("isMonto", Monto_valida);
	objform1.CJX23MON.validateMonto();

	function novalidar(){
		objform1.CJX23MON.required = false;
		objform1.CJX23MON.required = false;
		
		if (document.form1.CJX23TIP.value == "C"){
			objform1.CJX23CHK.required = false;
			objform1.CJX5IDE.required = false;
		}
		else 
		if (document.form1.CJX23TIP.value == "V"){
			objform1.CJX5IDE.required = false;
		}	
		else
		if (document.form1.CJX23TIP.value == "E"){
			objform1.CJX23CHK.required = false;
			objform1.CJX5IDE.required = false;
		}
		else
		if (document.form1.CJX23TIP.value == "T"){
			//objform1.CP9COD.required = false;
			objform1.EMPCED.required = false;
			objform1.TR01NUT.required = false;
			objform1.CJX23AUT.required = false;
			objform1.CJX23FEC.required = false;
		}			
	}


	function finalizar(){
		document.form1.CJX23CON.disabled = false;
		document.form1.CJX5IDE.disabled = false;
		document.form1.CJX23TIP.disabled = false;
		document.form1.CJX23MON.value = qf(document.form1.CJX23MON)
	}
	function validaREL(){
		<!---********************************************* --->
		<!--- se invoca el mismo cfm por medio de submit() --->
		<!--- para refrescar la lista segun la relacion    --->
		<!--- que se selecciona en el combo                --->
		<!---********************************************* --->
		doc = document.form1 ;
		doc.action = "";
		doc.submit();
	}
	function CARGATJ(){
		if (document.form1.TR01NUT.value.length < 9)	{
			var cont = 0 ;
			<cfoutput query="rsTarjetas">
				if (('#Trim(rsTarjetas.TR01NCO)#'==document.form1.TR01NUT.value) && ('#Trim(rsTarjetas.TS1COD)#' == document.form1.TS1COD.value)) 
				{
					cont ++;
					document.form1.TR01NUT.value = '#rsTarjetas.TR01NUT#';
				}
			</cfoutput>		
			
			 if (cont== 0) {
				document.form1.TR01NUT.value = ""
			 }
		}
	}
	function TRAE_AUTO(obj){		
		var CJX12AUT  = obj.value
		var PERCOD    = document.form1.PERCOD.value
		var MESCOD    = document.form1.MESCOD.value
		var TS1COD    = document.form1.TS1COD.value
		var TR01NUT   = document.form1.TR01NUT.value
		var CJM00COD  = document.form1.CJM00COD.value
		var params = "?CJX12AUT="+CJX12AUT+"&PERCOD="+PERCOD+"&MESCOD="+MESCOD+"&TS1COD="+TS1COD+"&TR01NUT="+TR01NUT+"&CJM00COD="+CJM00COD;		
		var frame = document.getElementById("FRAMEAUTO");
		frame.src = "/cfmx/sif/fondos/operacion/CargaAuto.cfm"+params;				
	}
	
	validaTIP()
	
	function listatarjetas(dato){
		var formato   	=  "left=400,top=250,scrollbars=yes,resizable=yes,width=350,height=200"
		var direccion 	= "/cfmx/sif/fondos/Utiles/cjc_tarjetas.cfm?dato="+dato
		open(direccion,"",formato);	
	}
	function Llenado_Auto (){

		var frame = document.getElementById("FRAMEAUTO");
		var CJX19REL		= document.form1.CJX19REL.value;
		params = "?CJX19REL="+CJX19REL+"&TIPO=A";
		frame.src = "/cfmx/sif/fondos/operacion/cjc_CargaAuto.cfm"+params;
	}
	
	fm(document.form1.CJX23MON,2)
</script> 

<script language="JavaScript" type="text/javascript">
	function Valida() 
	{
		if(document.form1.TR01NUT.value==''){
			alert('Se requiere un No. de Tarjeta para seleccionar un Voucher');
			document.form1.TR01NUT.focus();
			return false
		}
		return true
	}
	
	var popUpWin = 0;

	function popUpWindowVoucher(URLStr, left, top, width, height) 
	{
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function ConlisVoucher() 
	{
		if (Valida()) {
			var params = "form=form1&TR01NUT=" + document.form1.TR01NUT.value
				   	   + "&PERCOD=" + document.form1.PERCOD.value
				       + "&MESCOD=" + document.form1.MESCOD.value
				       + "&CJX19REL=" + document.form1.CJX19REL.value
				       + "&CJX23TIP=" + document.form1.CJX23TIP.value
				       + "&TS1COD=" + document.form1.TS1COD.value
				       + "&EMPCOD=" + document.form1.EMPCOD.value
					   + "&CJM00COD=" + document.form1.CJM00COD.value
					   
			popUpWindowVoucher("/cfmx/sif/fondos/Utiles/cjc_traeVoucher.cfm?"+params,250,200,650,400);
		}
	}

</script>

