<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0 >
	<cfset  form.modo = url.modo >
</cfif>
<!---********************************* --->
<!---** para entrar en modo cambio  ** --->
<!---********************************* --->
<cfif form.CJX19REL EQ "0">
	<cfset modo="ALTA">
	<cfset mododet="ALTA">
<cfelseif isdefined("Form.Cambio")>
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
<cfif modo neq "ALTA">
<!---************* CAmbio ********** --->
<!---********************************************************* --->
<!---** para verificar el valor de la llave y coloca en var ** --->
<!---********************************************************* --->
	<cfif isdefined("url.CJX20NUM") and len(trim(url.CJX20NUM)) gt 0>
		<cfset  form.CJX20NUM = url.CJX20NUM >
	</cfif>
<!---********************************************************* --->
<!---**aqui se definen las diferentes consultas SQL         ** --->
<!---********************************************************* --->
	<cfquery datasource="#session.Fondos.dsn#"  name="TraeSql" >	
		select
		CJX19REL,CJX20NUM,CJX20TIP,PROCOD,CJX20NUF,convert(varchar(10),CJX20FEF,103)CJX20FEF,EMPCOD,
		convert(varchar(20),CJX20TOT,1)  CJX20TOT,
		convert(varchar(20),CJX20DES,1)  CJX20DES,
		convert(varchar(20),CJX20MUL,1)  CJX20MUL,
		convert(varchar(20),CJX20RET,1)  CJX20RET,
		convert(varchar(20),CJX20IMP,1)  CJX20IMP,
		convert(varchar(20),CJX20MNT,1)  CJX20MNT,
		NETO= convert(varchar(20),CJX20TOT-(CJX20MUL+CJX20DES+CJX20RET),1),
		CP9COD,I04COD,timestamp
				FROM CJX020 
		where CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CJX19REL#" >
		and   CJX20NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CJX20NUM#" >
	</cfquery>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSql.timestamp#" returnvariable="ts">
	</cfinvoke>
	<cfquery name="rsEmpleado" datasource="#session.Fondos.dsn#">
		SELECT EMPCOD,EMPCED,EMPNOM +' '+EMPAPA+' '+EMPAMA  NOMBRE FROM PLM001 
		where  EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.EMPCOD#" >
	</cfquery>
	
	<cfquery name="rsDepartamento" datasource="#session.Fondos.dsn#">
			SELECT DEPCOD,DEPDES 
			FROM PLX002,CJM017 
			where DEPCOD = I04COD
			and   DEPCOD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.I04COD#">
	</cfquery>
	
	<cfquery name="rsProveedor" datasource="#session.Fondos.dsn#">
			SELECT PROCED,PROCOD,PRONOM FROM CPM002  
			where   PROCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.PROCOD#">
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
<cfquery name="rsRelacion" datasource="#session.Fondos.dsn#">
	select   CJX19REL,'REL-'+ convert(varchar,CJX19REL) CJX19DES from CJX019 
	WHERE  CJ01ID  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Caja#">
	AND CJX19EST = 'D'
</cfquery>
<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>
<table width="100%" border="0" >
	<tr>
		<td width="50%"  align="left" >
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
			<cfoutput>
					<table width="100%" border="0">
					  <!---********************************************************* --->
					  <tr>
						<td width="13%"><strong>SubFondo:</strong></td>
						<td width="28%">#session.Fondos.Caja#</td>
						<td width="9%"><strong>Usuario :</strong></td>
						<td width="44%">#session.usuario#</td>
					  </tr>
  					  <!---********************************************************* --->
					  <tr>
						<td><strong>Moneda :</strong></td>
						<td>#session.Fondos.MonedaDes#</td>
						<td><strong>No. :</strong></td>
						<td width="44%"><select name="CJX19REL" onChange="validaREL()" tabindex="1">
                      		<option value="0">Nueva</option>
                      		<cfloop query="rsRelacion"> 
                        	<option value="#CJX19REL#" <cfif Form.CJX19REL EQ rsRelacion.CJX19REL>selected</cfif>>#CJX19DES#</option>
                      		</cfloop> </select>
						</td>
					  </tr>
					  <!---********************************************************* --->	
<!--- 					  <tr>
						<td colspan="4"><hr></td>
					  </tr> --->
					  <!---********************************************************* --->	
					  
					  <cfif modo neq "ALTA">
						  <tr>
							<td ><strong>Operación:</strong></td>
							<td colspan="4" >	
								<INPUT 	TYPE="textbox" 
										NAME="CJX20NUM" 
										VALUE="#TraeSql.CJX20NUM#" 
										SIZE="20" 
										DISABLED 
										tabindex="1"
										MAXLENGTH="11" 
										ONBLUR="" 
										ONFOCUS="this.select(); " 
										ONKEYUP="" 
										style="border: medium none; text-align:left; size:auto;"
								>
							</td>
						  </tr>			
					 <cfelse>
					  	<input type="hidden" style="visibility:hidden" name="CJX20NUM" value="" DISABLED >
					  </cfif>		
					  	  

					  <!---********************************************************* --->
					  <tr>
						<td ><strong>Tipo Liq.:</strong></td>
						<TD><SELECT NAME="CJX20TIP" onchange="validaLIQ()" tabindex="1">
						<OPTION  VALUE="F" <cfif modo NEQ 'ALTA' and TraeSql.CJX20TIP eq "F" >selected</cfif>>FACTURA</OPTION>
						<OPTION  VALUE="V" <cfif modo NEQ 'ALTA' and TraeSql.CJX20TIP eq "V" >selected</cfif>>VIATICOS Y OTROS</OPTION>
						<OPTION  VALUE="A" <cfif modo NEQ 'ALTA' and TraeSql.CJX20TIP eq "A" >selected</cfif>>AJUSTES</OPTION>
						</SELECT>
						</TD>
					  </tr>
					  <!---********************************************************* --->			
					  <tr>
						<td ><strong>Empleado:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >
								<cf_cjcConlis 	
										size		="30"  
										tabindex    ="1"
										name 		="EMPCED" 
										desc 		="NOMBRE" 
										id			="EMPCOD" 
										name2		="DEPCOD"
										desc2		="DEPDES"										
										cjcConlisT 	="cjc_traeEmp"
										query       ="#rsEmpleado#"
										frame		="EMPCED_FRM"
								>			
							<cfelse>
								<cf_cjcConlis 	
										size		="30" 
										tabindex    ="1" 
										name 		="EMPCED" 
										desc 		="NOMBRE" 
										id			="EMPCOD" 
										name2		="DEPCOD"
										desc2		="DEPDES"
										cjcConlisT 	="cjc_traeEmp"
										frame		="EMPCED_FRM"
								>
							 </cfif>
						</td>
					  </tr>	

					  <!---********************************************************* --->
					  <tr>
					  <td ><strong>C. Fun/Ges:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >
								<cf_cjcConlis 	
										size		="30" 
										tabindex    ="1" 
										name 		="DEPCOD" 
										desc 		="DEPDES" 
										cjcConlisT 	="cjc_traeDep"
										query       ="#rsDepartamento#"
										frame		="DEPCOD_FRM"

								>
							<cfelse>
								<cf_cjcConlis 	
									size		="30"  
									tabindex    ="1"
									name 		="DEPCOD" 
									desc 		="DEPDES" 
									cjcConlisT 	="cjc_traeDep"
									frame		="DEPCOD_FRM"
								>
							</cfif>	
						</td>
					  </tr>	
					  <!---********************************************************* --->
					  <tr>
					  <td ><strong>Autorizador:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >
								<cf_cjcConlis 	
										size		="30"  
										tabindex    ="1"
										name 		="CP9COD" 
										desc 		="CP9DES" 
										cjcConlisT 	="cjc_traeAut"
										query       ="#rsAutorizador#"
										frame		="CP9COD_FRM"
								>
							<cfelse>	
								<cf_cjcConlis 	
										size		="30"  
										tabindex    ="1"
										name 		="CP9COD" 
										desc 		="CP9DES" 
										cjcConlisT 	="cjc_traeAut"
										frame		="CP9COD_FRM"
								>
							</cfif>	
						</td>
					  </tr>
					  <!---******************************************************* --->
					  <tr>
					  <td ><strong>Proveedor:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >	
								<cf_cjcConlis 	
										size		="30"  
										tabindex    ="1"
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="PROCOD" 
										onfocus		="validaProv()" 
										cjcConlisT 	="cjc_traeProv"
										query       ="#rsProveedor#"
										frame		="PROCED_FRM"
								>
							<cfelse>	
								<cf_cjcConlis 	
										tabindex    ="1"
										size		="30"  
										name 		="PROCED" 
										desc 		="PRONOM" 
										id			="PROCOD" 
										onfocus		="validaProv()" 
										cjcConlisT 	="cjc_traeProv"
										frame		="PROCED_FRM"
								>
							</cfif>
						</td>
					  </tr>
					  
					  <!---********************************************************* --->	
					  <tr>
					    <cfif modo neq 'ALTA' >
							<cfset CJX20FEF = TraeSql.CJX20FEF >
						<cfelse>
							<cfset CJX20FEF = "" >
						</cfif>
						<td ><strong>Fecha:</strong></td>
						<td colspan="4" valign="baseline" nowrap>	
							<cf_CJCcalendario  tabindex    ="1" name="CJX20FEF" form="form1"  value="#CJX20FEF#">
						</td>
					  </tr>

					  <!---********************************************************* --->	
					  <tr>
					  	<td ><strong>No. Factura:</strong></td>
						<td colspan="4" >	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20NUF" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20NUF#</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select();validaFac(); " 
									ONKEYUP="" 
									tabindex="1"
							>
						</td>
					  </tr>					  
					  <!---********************************************************* --->	
					  <tr>
					  	<td ><strong>Subtotal:</strong></td>
						<td colspan="4">	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20TOT" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20TOT#<cfelse>0.00</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									DISABLED 
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									style="border: medium none; text-align:left; size:auto;"
									tabindex="1"
							>
						</td>
					  </tr>		
				  <!---********************************************************* --->	
					  <tr>
					  	<td ><strong>Multas:</strong></td>
						<td>	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20MUL" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20MUL#<cfelse>0.00</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="javascript: fm(this,2);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 
									tabindex="1"
							>
						</td>
					  	<td align="right" ><strong>Neto:</strong></td>
						<td>	
							<INPUT 	TYPE="textbox" 
									NAME="NETO" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.NETO#<cfelse>0.00</cfif>"  
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									DISABLED 
									tabindex="1"
									style="border: medium none; text-align:left; size:auto;"
							>
						</td>
					    <td width="6%">&nbsp;</td>
					  </tr>		
				  <!---********************************************************* --->	
					  <tr>
					  	<td ><strong>Descuento:</strong></td>
						<td >	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20DES" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20DES#<cfelse>0.00</cfif>"
									SIZE="20" 
									MAXLENGTH="15" 
									tabindex="1"
									ONBLUR="javascript: fm(this,2);" 
									ONFOCUS="javascript: this.value=qf(this); this.select(); " 
									ONKEYUP="javascript: if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur();}} " 

							>
						</td>
					  	<td align="right" ><strong>Impuestos:</strong></td>
						<td>	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20IMP" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20IMP#<cfelse>0.00</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									DISABLED 
									tabindex="1"
									style="border: medium none; text-align:left; size:auto;"
							>
						</td>
					    <td width="6%">&nbsp;</td>
					  </tr>		
				  <!---********************************************************* --->	
					  <tr>
					  	<td ><strong>Retención:</strong></td>
						<td>	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20RET" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20RET#<cfelse>0.00</cfif>" 
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									tabindex="1"
							>
						</td>
					  	<td align="right" ><strong>Total:</strong></td>
						<td>	
							<INPUT 	TYPE="textbox" 
									NAME="CJX20MNT" 
									VALUE="<cfif modo neq "ALTA">#TraeSql.CJX20MNT#<cfelse>0.00</cfif>"  
									SIZE="20" 
									MAXLENGTH="15" 
									ONBLUR="" 
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									DISABLED 
									tabindex="1"
									style="border: medium none; text-align:left; size:auto;"
							>
						</td>
					    <td width="6%">&nbsp;</td>
					  </tr>	
				  <!---********************************************************* --->	
					</table>	
					<input 	name="timestamp" 
							type="hidden" 
							id="timestamp" 
							style="visibility:hidden" 
							value="<cfif modo NEQ "ALTA" ><cfoutput>#ts#</cfoutput></cfif>"
					>				
			</cfoutput>		
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
  	</tr>
</table>
