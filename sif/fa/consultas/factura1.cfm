<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery name="tipos" datasource="#session.dsn#">
	select Doc_CCTcodigo from HDPagos DP where REPLACE(LTRIM(RTRIM(Pcodigo)), '        ', '') = REPLACE(LTRIM(RTRIM(<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Pcodigo#">)), ' ', '')
</cfquery>

<cfquery name="TRANSACCION" datasource="#session.dsn#">
    select CASE PFP.Tipo WHEN 'E' THEN 'Efectivo'
                 WHEN 'T' THEN 'Tarjeta'
				 WHEN 'D' THEN 'Deposito'
				 WHEN 'A' THEN 'Documento'
				 WHEN 'C' THEN 'Cheque'
                 ELSE 'sin asignar'
      END AS Tipos,
      cast(ET.ETdocumento as varchar) + REPLACE(LTRIM(RTRIM(cast(ET.ETserie as varchar))), '        ', '')+ '-'+ cast(ET.ETnumero as varchar) as recibo,
 	  D.Pnombre+' '+ D.Papellido1 as vendedor,
	  DT.DTcant, DT.DTdescripcion, DT.DTtotal, b.Enombre, b.Etelefono1, d.direccion1, d.ciudad, d.estado, d.codPostal, M.Mnombre, M.Miso4217, ET.ETnombredoc as nombredoc, 
	  Convert(varchar(10),CONVERT(date,DT.DTfecha,106),103) as fecha, D.Pnombre, D.Papellido1, P.Ptotal, P.fechaExpedido, DP.DPtotal, SN.SNnombre
	  from HPagos P, HDPagos DP, ETransacciones ET, DTransacciones DT, Usuario U, DatosPersonales D,Empresas a, Empresa b, Direcciones d, Monedas M,
	  		<cfswitch expression='#tipos.Doc_CCTcodigo#'> 
			    <cfcase value="FC"> 
			        PFPagos PFP,
			    </cfcase> 
			    <cfcase value="FA"> 
			        FPagos PFP, 
			    </cfcase> 			    
			</cfswitch>
	  SNegocios SN
	  where
	  concat(ET.ETserie, '', ET.ETdocumento, '') = DP.Ddocumento 
	  and P.Pcodigo = DP.Pcodigo
	  and U.Usucodigo = ET.Usucodigo
	  and U.datos_personales = D.datos_personales
	  and a.EcodigoSDC = b.Ecodigo 
	  and b.id_direccion = d.id_direccion
	  	<cfswitch expression='#tipos.Doc_CCTcodigo#'> 
		    <cfcase value="FC1"> 
		        and PFP.Pcodigo = DP.Pcodigo
		    </cfcase> 
		    <cfcase value="FA1"> 
		        and PFP.ETnumero = ET.ETnumero
		    </cfcase> 			    
		</cfswitch>
	  and DT.ETnumero = ET.ETnumero
	  and SN.SNcodigo = P.SNcodigo 
	  and P.Pcodigo =<cfqueryparam cfsqltype="cf_sql_varchar" value='#url.Pcodigo#'>
</cfquery>
<cfreport format="PDF" query="TRANSACCION" template="RptePago.cfr">
</cfreport>
