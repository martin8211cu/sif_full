<link href="/cfmx/sif/fondos/css/sif.css" rel="stylesheet" type="text/css">
<title>Caratula de Liquidaciones de Fondos</title>
<script language="javascript1.2" type="text/javascript">
//----------------------------------------------------------------------
function imprimir() 
{		
	var tablabotones = document.getElementById("tablabotones");	
	tablabotones.style.display = 'none';	
	window.print();	
	tablabotones.style.display = ''
}
</script>
<script language="javascript">
function refrescarpadre()
{
	window.opener.location = 'cjc_Referencias.cfm';
}
</script>

<cfif not isdefined("VTPrevia")>

	<cfif not isdefined("soloconsulta")>

		<!--- Se Genera la referencia que se va a asignar --->
		<cftry>
		
			<cfquery datasource="#session.Fondos.dsn#" name="NuevaRef">
				set nocount on 
					
				exec sp_RetornaReferencia
					@usuario = '#session.usuario#'
					
				set nocount off 
			</cfquery>
				
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<script language="JavaScript">
					var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
					mensaje = mensaje.substring(40,300)
					alert(mensaje)
					history.back()
				</script>
				<cfabort>
			</cfcatch>
			
		</cftry>		
				
		<cfset ReferenciaGen = NuevaRef.ReferenciaFinal>
		
		<cftransaction>
		<cftry>
		
			<!--- Se Recorren las Liquidaciones Marcadas --->
			<cfset fechahoy = dateformat(NOW(),"yyyymmdd")>
			
			<cfquery datasource="#session.Fondos.dsn#">
				UPDATE CJX004 
					SET CJX04REF2 ='#ReferenciaGen#' , 
						CJX04FRD ='#fechahoy#' , 
						CJX04URD ='#session.usuario#',
						CJX04IND = 'N' 
				WHERE CJX04IND = 'S'
				  AND CJX04REF2 is null
				  AND CJX04UMK = '#session.usuario#'				  
			</cfquery>		
		<!--- 

			<cfloop list="#DCM#" delimiters="," index="valor">
			
				<!--- Se separa el fondo de la relacion --->
				<cfset pos = #find("-",valor,1)#>
				<cfif pos neq 0>
				
					<cfset fondo=#Mid(valor,1,pos-1)#>
					<cfset liquidacion=#Mid(valor,pos+1,len(valor))#>
					
					<cfquery datasource="#session.Fondos.dsn#">
						UPDATE CJX004 
							SET CJX04REF2 ='#ReferenciaGen#' , 
								CJX04FRD ='#fechahoy#' , 
								CJX04URD ='#session.usuario#',
								CJX04IND = 'N' 
						WHERE CJM00COD ='#fondo#' 
						  AND CJX04NUM =#liquidacion#
					</cfquery>
				
				</cfif>
				
			</cfloop>
		 --->
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<script language="JavaScript">
					var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
					mensaje = mensaje.substring(40,300)
					alert(mensaje)
					history.back()
				</script>
				<cfabort>
			</cfcatch>
			
		</cftry>
		<cftransaction action="commit"/>
		</cftransaction>	

		<script>refrescarpadre()</script>
	</cfif>

	<cfquery datasource="#session.Fondos.dsn#" name="datos">
	<!---
	select distinct A.CJM00COD, A.CJX04NUM, A.CJX04FEC, C.CGE20NOC, 
					B.CG5CON,   B.CGTBAT,   convert(varchar,isnull(A.CJX04MON,0) + isnull(A.CJX04TGT,0),1)  as CJX04MON,
					convert(varchar, (select sum(isnull(CJX04MON,0) + isnull(CJX04TGT,0)) 
					 from CJX004 D 
					 where CJX04REF2 = '#ReferenciaGen#'
					 ),1) as MTOTAL
	from CJX004 A, CGT003 B, CGE020 C
	where A.INTBAT = B.INTBAT
	  and A.CJX04URF = C.CGE20NOL
	  and A.CJX04REF2 = '#ReferenciaGen#'
	  and A.CJX04UMK = '#session.usuario#'
	Order by convert(int, A.CJM00COD), A.CJX04NUM,B.CG5CON, B.CGTBAT  
	--->

	select distinct A.CJM00COD, A.CJX04NUM, A.CJX04FEC, C.CGE20NOC, 
				case when B.CG5CON is null then 'N/A' else convert(varchar,B.CG5CON) end as CG5CON,   
				case when B.CGTBAT is null then 'N/A' else convert(varchar,B.CGTBAT) end as CGTBAT,
                convert(varchar,isnull(A.CJX04MON,0) + isnull(A.CJX04TGT,0),1)  as CJX04MON,
				convert(varchar, (select sum(isnull(CJX04MON,0) + isnull(CJX04TGT,0)) 
								 from CJX004 D 
								 where CJX04REF2 = '#ReferenciaGen#'),1) as MTOTAL
	from CJX004 A 
 		left join CGT003 B
			on A.INTBAT = B.INTBAT

		inner join CGE020 C
		    on A.CJX04URF  = C.CGE20NOL

	where A.CJX04REF2 = '#ReferenciaGen#'
	  and A.CJX04UMK = '#session.usuario#'
	Order by convert(int, A.CJM00COD), A.CJX04NUM,B.CG5CON, B.CGTBAT
	</cfquery>
	

</cfif>

<body topmargin="0" leftmargin="0">

<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
<tr>
	<td>&nbsp;</td>
	<td align="left" nowrap>
	<form action="cjc_CaratulaReferencias.cfm" method="post" name="frm_caratula">
	<input type="button"  id="Cerrar" name="Cerrar" value="Cerrar" onClick="javascript:window.close();">
	<input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="javascript:imprimir();">
	<cfif isdefined("VTPrevia")>
		<input type="button"  id="Aplicar" name="Aplicar" value="Aplicar" onClick="javascript:document.frm_caratula.submit();">	
		<cfif isdefined("session.VPrevia")>
			<cfloop collection="#session.VPrevia#" item="i">			
				<input type="hidden" name="DCM" value="<cfoutput>#session.VPrevia[i][2]#-#session.VPrevia[i][3]#</cfoutput>">
			</cfloop>
		</cfif>		
	</cfif>	
	</form>
	</td>
</tr>
<tr><td colspan="2"><hr></td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
</table>

<table align="center" border="1" cellpadding="0" cellspacing="0" width="650">
<tr>
	<td align="center">

		<table align="center" border="0" cellpadding="0" cellspacing="0" width="650">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><font size="+2" face="Arial Narrow">Liquidaciones de Fondos</font></td>
				</tr>
				<cfif isdefined("VTPrevia")>
				<tr>
					<td align="center"><font size="2" face="Arial Narrow">Vista Previa</font></td>
				</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				</table>
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center"><strong><font size="4" face="Times New Roman, Times, serif">Ref.</font></strong></td>
				</tr>
				</table>	
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center"><strong><font size="12" face="Times New Roman, Times, serif"><cfoutput>#ReferenciaGen#</cfoutput></font></strong></td>
				</tr>
				</table>	
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" class="areaFiltro" cellspacing="0" width="90%">
				<tr>
					<td>
		
						<table align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td width="13%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Fondo</font></strong></td>
							<td width="15%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">No. Liquidacion</font></strong></td>
						    <td width="14%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Fecha<br>Liquidacion</font></strong></td>
							<td width="22%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Encargado de<br>Fondo</font></strong></td>
							<td width="10%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Lote</font></strong></td>
							<td width="9%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Consec.</font></strong></td>
							<td width="17%" align="center"><strong><font size="3" face="Times New Roman, Times, serif">Monto</font></strong></td>							
						</tr>
						<tr><td colspan="7"><hr width="95%" align="center"></td></tr>
						<cfset consec = 1>
						<cfset MTOTAL=0>
						<cfif not isdefined("VTPrevia")>
												
							<cfoutput query="datos">
								<tr>
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#CJM00COD#</strong></font></td>
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#CJX04NUM#</strong></font></td>
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#dateformat(CJX04FEC,"dd/mm/yyyy")#</strong></font></td>
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#Mid(CGE20NOC,1,25)#</strong></font></td>									
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#CG5CON#</strong></font></td>
									<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong>#CGTBAT#</strong></font></td>
									<td align="right"><font size="2" face="Times New Roman, Times, serif"><strong>&cent;#CJX04MON#</strong></font></td>
								</tr>	
								<cfset consec = consec + 1>
								<!--- <cfset MTOTAL=MTOTAL + CJX04MON> --->
							</cfoutput>	
						
						<cfelse>
						
							<!--- Entra en modo de Vista Previa --->
							<cfif isdefined("session.VPrevia")>
								
								<cfset listallaves = #listsort(StructKeyList(session.VPrevia,","),"numeric")#>
								<cfloop list="#listallaves#" delimiters="," index="valor">

									<cfset arreglo = ArraytoList(session.VPrevia[valor],",")>
																
									<tr>										
										<cfset cuenta = 1>
										<cfloop list="#arreglo#" delimiters="," index="ind">

											<cfif cuenta eq 8>
												<cfset MTOTAL=MTOTAL + #ind#>
												<td align="right"><font size="2" face="Times New Roman, Times, serif"><strong>&cent;<cfoutput>#NumberFormat(ind,",9.99")#</cfoutput></strong></font></td>
											<cfelse>
												<cfif cuenta gt 1>
													<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#ind#</cfoutput></strong></font></td>
												</cfif>
											</cfif>
											<cfset cuenta = cuenta + 1>
										</cfloop>																					
									</tr>	
									
								</cfloop>
																
								<!--- <cfloop collection="#session.VPrevia#" item="i">									
									
									<cfset MTOTAL=MTOTAL + #session.VPrevia[i][8]#>
									<tr>										
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][2]#</cfoutput></strong></font></td>
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][3]#</cfoutput></strong></font></td>
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][4]#</cfoutput></strong></font></td>
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][5]#</cfoutput></strong></font></td>
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][6]#</cfoutput></strong></font></td>
										<td align="center"><font size="2" face="Times New Roman, Times, serif"><strong><cfoutput>#session.VPrevia[i][7]#</cfoutput></strong></font></td>
										<td align="right"><font size="2" face="Times New Roman, Times, serif"><strong>&cent;<cfoutput>#NumberFormat(session.VPrevia[i][8],",9.99")#</cfoutput></strong></font></td>
									</tr>	
								</cfloop> --->
																					
							</cfif>
						
						</cfif>		
					  </table>	
				
					</td>	
				</tr>
				</table>				
			
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table cellpadding="0" cellspacing="0" width="90%" align="center">
				<tr>
					<td width="80%" align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Monto Total de Liquidaciones:&nbsp;&nbsp;</strong></font></td>
					<td width="20%" align="right"><font size="2" face="Times New Roman, Times, serif"><strong>&cent;<cfif not isdefined("VTPrevia")><cfoutput>#datos.MTOTAL#</cfoutput><cfelse><cfoutput>#NumberFormat(MTOTAL,",9.99")#</cfoutput></cfif></strong></font></td>
				</tr>
				<tr>
					<td align="right"><font size="2" face="Times New Roman, Times, serif"><strong>Cantidad Total de Liquidaciones:&nbsp;&nbsp;</strong></font></td>
					<td align="right"><font size="2" face="Times New Roman, Times, serif"><strong><cfif not isdefined("VTPrevia")><cfoutput>#datos.recordcount#</cfoutput><cfelse><cfoutput>#StructCount(session.VPrevia)#</cfoutput></cfif></strong></font></td>
				</tr>				
				</table>
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center"><strong><font size="4" face="Times New Roman, Times, serif"><cfoutput>#session.usuario#</cfoutput></font></strong></td>
				</tr>
				</table>	
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
			
				<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center"><strong><font size="3" face="Times New Roman, Times, serif"><cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></font></strong></td>
				</tr>
				</table>	
			
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>				
		</table>

	</tr>
</tr>
</table>

</body>
