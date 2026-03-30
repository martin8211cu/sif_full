<cfif isdefined("form.ExportarAmexo")>
	<cfparam name="form.eiid" default="">
	<cfif Len(form.eiid) EQ 0>
		<cflocation url="Exportar.cfm?Form.AnexoId=#Form.AnexoId#">
	</cfif>
	<cfquery datasource="#session.dsn#" name="ret_ane">

    select * from Anexo where AnexoId=#Form.AnexoId#
	</cfquery>
	<cfquery datasource="#session.dsn#" name="ret_hoj">
	select DISTINCT AnexoHoja from AnexoCel where AnexoId=#Form.AnexoId# and AnexoHoja in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#form.eiid#">)
	</cfquery>
<cfsetting enablecfoutputonly="yes">
<cfcontent type="text/plain">
<cfheader name="Content-Disposition" value="attachment; filename=Anexo.xml">
<cfoutput><?xml version="1.0" encoding="ISO-8859-1"?>
		  <Anexo>
			<AnexoDes>#ret_ane.AnexoDes#</AnexoDes>
			<Libro>
				<cfloop query="ret_hoj">
					<hoja>
						<AnexoHoja>#Trim(ret_hoj.AnexoHoja)#</AnexoHoja>
						<Celdas>
							<cfquery datasource="#session.dsn#" name="ret_cel">
		      select * from AnexoCel where AnexoId=#Form.AnexoId# and AnexoHoja='#ret_hoj.AnexoHoja#'
		      </cfquery>
							<cfloop query="ret_cel">
								<Celda>
									<AnexoId>#ret_cel.AnexoId#</AnexoId>
									<AnexoHoja>#Trim(ret_cel.AnexoHoja)#</AnexoHoja>
									<AnexoRan>#Trim(ret_cel.AnexoRan)#</AnexoRan>
									<AnexoCon>#ret_cel.AnexoCon#</AnexoCon>
									<AnexoMes>#ret_cel.AnexoMes#</AnexoMes>
									<AnexoPer>#ret_cel.AnexoPer#</AnexoPer>
									<AnexoNeg>#ret_cel.AnexoNeg#</AnexoNeg>
									<AnexoRel>#ret_cel.AnexoRel#</AnexoRel>
									<AVid>#ret_cel.AVid#</AVid>
									<Detalle>
										<cfquery datasource="#session.dsn#" name="ret_celD">
			                        select * from AnexoCelD where AnexoCelId=#ret_cel.AnexoCelId#
			                        </cfquery>
										<cfloop query="ret_celD">
											<CeldaD>
												<Ecodigo>#ret_celD.Ecodigo#</Ecodigo>
												<Cmayor>#ret_celD.Cmayor#</Cmayor>
												<AnexoCelFmt>#ret_celD.AnexoCelFmt#</AnexoCelFmt>
												<AnexoCelMov>#ret_celD.AnexoCelMov#</AnexoCelMov>
												<AnexoSigno>#ret_celD.AnexoSigno#</AnexoSigno>
												<PCDcatid>#ret_celD.PCDcatid#</PCDcatid>
												<Anexolk>#ret_celD.Anexolk#</Anexolk>
												<BMUsucodigo>#ret_celD.BMUsucodigo#</BMUsucodigo>
											</CeldaD>
										</cfloop>
									</Detalle>
								</Celda>
							</cfloop>
						</Celdas>
					</hoja>
				</cfloop>
			</Libro>
		  </Anexo>
	</cfoutput>

</cfif>
<cfif isdefined("form.ImportarAmexo")>
	<cffile action="read" variable="filecontents" file="#form.file#">
	<cfset anexo = XmlParse(filecontents)>
	<cfoutput>

<cfset numHojas = ArrayLen(anexo.Anexo.Libro.XmlChildren)>


<cfloop index="i" from = "1" to = #numHojas#>

<cfset numItemsC = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.XmlChildren)>

</cfloop>
 <cfset errorHoja=''>
<cfset errorCelda=''>
<cfset errorCuenta=''>
<cfset finInsercion=''>

 <cfloop index="i" from = "1" to = #numHojas#>
	  <cfquery datasource="#session.dsn#" name="val_hoj">
		  <cfset varHoja=Trim(#anexo.Anexo.Libro.hoja[i].AnexoHoja.XmlText#)>

        select * from AnexoCel where AnexoId=#Form.AnexoId# and AnexoHoja='#anexo.Anexo.Libro.hoja[i].AnexoHoja.XmlText#'

	  </cfquery>

	  <cfif  #val_hoj.RecordCount# eq 0>
	  <cfset errorHoja=errorHoja&' '&replace(#anexo.Anexo.Libro.hoja[i].AnexoHoja.XmlText#,' ','','ALL')&','>
	  </cfif>
	  </cfloop>


	  <cfif #errorHoja# eq ''>
		  <cfloop index="i" from = "1" to = #numHojas#>
          <cfset numCeldas = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.XmlChildren)>
		  <cfloop index="a" from = "1" to = #numCeldas#>

			  <cfquery datasource="#session.dsn#" name="val_cel">
				  select * from AnexoCel where AnexoId=#Form.AnexoId# and AnexoHoja='#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoHoja.XmlText#' and AnexoRan='#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoRan.XmlText#'
			  </cfquery>
			  <cfif  #val_cel.RecordCount# eq 0>
	          <cfset errorCelda=errorCelda&' '&replace(#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoHoja.XmlText#,' ','','ALL')&' / '&replace(#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoRan.XmlText#,' ','','ALL')&','>
	          </cfif>

		  </cfloop>

          </cfloop>

	  </cfif>

        <cfset cuentaList ="">

	   <cfif #errorHoja# eq '' and #errorCelda# eq ''>
		  <cfloop index="i" from = "1" to = #numHojas#>
              <cfset numCeldas = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.XmlChildren)>
		      <cfloop index="a" from = "1" to = #numCeldas#>
			      <cfset numCeldasD = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.XmlChildren)>
			      <cfloop index="b" from = "1" to = #numCeldasD#>
				     <cfif  #ListLen(cuentaList,',')# eq 0>
				      <cfset cuentaList =listAppend(cuentaList,"#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Cmayor.XmlText#",",")>
				      </cfif>
				      <cfset num=0>
				      <cfloop list="#cuentaList#" index="cuenta">
                          <cfif #cuenta# eq #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Cmayor.XmlText#>
							 <cfset num=1>
						  </cfif>
                       </cfloop>
					   <cfif #num# eq 0>
						  <cfset cuentaList =listAppend(cuentaList,"#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Cmayor.XmlText#",",")>
					   </cfif>
				  </cfloop>
			  </cfloop>
          </cfloop>
		  <cfloop list="#cuentaList#" index="cuenta">
                 <cfquery datasource="#session.dsn#" name="val_cue">
					 select * from CtasMayor where Cmayor=#cuenta#
				 </cfquery>
				 <cfif  #val_cue.RecordCount# eq 0>
					   <cfset errorCuenta=errorCuenta&' '&#cuenta#&','>
	             </cfif>
           </cfloop>

	   </cfif >

	   <cfif #errorHoja# eq '' and #errorCelda# eq '' and #errorCuenta# eq ''>
       <cfloop index="i" from = "1" to = #numHojas#>
              <cfset numCeldas = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.XmlChildren)>

		      <cfloop index="a" from = "1" to = #numCeldas#>
			      <cfquery datasource="#session.dsn#" name="res_cel">
				     select * from AnexoCel where AnexoId=#Form.AnexoId# and AnexoHoja='#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoHoja.XmlText#' and AnexoRan='#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoRan.XmlText#'
				  </cfquery>
				  <cfquery datasource="#session.dsn#" name="del_celD">
						delete from AnexoCelD where AnexoCelId=#res_cel.AnexoCelId#
				  </cfquery>

			      <cfset numCeldasD = ArrayLen(anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.XmlChildren)>
			      <cfloop index="b" from = "1" to = #numCeldasD#>

				      <cfquery datasource="#session.dsn#" name="add_celD">
				          INSERT INTO AnexoCelD (AnexoCelId, Ecodigo, Cmayor, AnexoCelFmt, AnexoCelMov, AnexoSigno, PCDcatid, Anexolk)
                          VALUES (#res_cel.AnexoCelId#, #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Ecodigo.XmlText#, #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Cmayor.XmlText#, '#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].AnexoCelFmt.XmlText#', '#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].AnexoCelMov.XmlText#', #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].AnexoSigno.XmlText#, <cfif #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].PCDcatid.XmlText# eq ''>NULL<cfelse>#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].PCDcatid.XmlText#</cfif>, #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].Detalle.CeldaD[b].Anexolk.XmlText#)
				      </cfquery>
				  </cfloop>
				  <cfif #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoCon.XmlText# neq ''>
				  <cfquery datasource="#session.dsn#" name="upd_cel">
					  <cfif #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AVid.XmlText# eq ''>
					   update AnexoCel set AnexoCon = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoCon.XmlText#, AnexoMes = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoMes.XmlText#, AnexoPer = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoPer.XmlText# ,AnexoNeg=#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoNeg.XmlText# ,AnexoRel= #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoRel.XmlText# where AnexoCelId = #res_cel.AnexoCelId#
					   </cfif>
					   <cfif #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AVid.XmlText# neq ''>
						 update AnexoCel set AnexoCon = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoCon.XmlText#, AnexoMes = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoMes.XmlText#, AnexoPer = #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoPer.XmlText# ,AnexoNeg=#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoNeg.XmlText# ,AnexoRel= #anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AnexoRel.XmlText# ,AVid=#anexo.Anexo.Libro.hoja[i].Celdas.Celda[a].AVid.XmlText#  where AnexoCelId = #res_cel.AnexoCelId#
					   </cfif>
				  </cfquery>
				  </cfif>
			  </cfloop>
          </cfloop>
		<cfset finInsercion='correcto'>
		</cfif>
<form name="form" id="from1" method="post" action="Importar.cfm?Form.AnexoId=#Form.AnexoId#">

	 <!---cfparam name="form.errorHoja"--->
	 <input type="hidden" name="errorHoja" value="#errorHoja#">
	 <input type="hidden" name="errorCElda" value="#errorCelda#">
	 <input type="hidden" name="errorCuenta" value="#errorCuenta#">
	 <input type="hidden" name="finInsercion" value="#finInsercion#">
	 <!---input type="submit" value="envia"--->


	  <!---cfif len(#val_hoj#)>
		no existe
	  </cfif--->



</form>
<!---cflocation url="Importar.cfm?Form.AnexoId=#Form.AnexoId#&errorHoja=1"--->

	</cfoutput>

	<script language="javascript" type="text/javascript">

       document.getElementById('from1').submit();

     </script>

</cfif>
