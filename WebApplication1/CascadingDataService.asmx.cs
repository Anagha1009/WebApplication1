using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

namespace WebApplication1
{
    /// <summary>
    /// Summary description for CascadingDataService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class CascadingDataService : System.Web.Services.WebService
    {

        [WebMethod]
        public void GetCountry()
        {
            List<Country> Countries = new List<Country>();
            using (SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString()))
            {
                SqlCommand SqlComm = new SqlCommand("stp_Emp_GetCountry",SqlConn);
                SqlComm.CommandType = CommandType.StoredProcedure;

                if(SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlDataReader SqlDR = SqlComm.ExecuteReader();

                while (SqlDR.Read())
                {
                    Country country = new Country();
                    country.Row_Id = Convert.ToInt32(SqlDR["Row_Id"]);
                    country.CountryName = SqlDR["CountryName"].ToString();
                    Countries.Add(country);
                }

                JavaScriptSerializer JS = new JavaScriptSerializer();
                Context.Response.Write(JS.Serialize(Countries));

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }
            }
        }

        [WebMethod]
        public void GetState(int CountryId)
        {
            List<State> States = new List<State>();
            using (SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString()))
            {
                SqlCommand SqlComm = new SqlCommand("stp_Emp_GetStateByCountryId", SqlConn);
                SqlComm.CommandType = CommandType.StoredProcedure;

                SqlParameter param = new SqlParameter()
                {
                    ParameterName = "@CountryId",
                    Value = CountryId
                };

                SqlComm.Parameters.Add(param);

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlDataReader SqlDR = SqlComm.ExecuteReader();

                while (SqlDR.Read())
                {
                    State state = new State();
                    state.Row_Id = Convert.ToInt32(SqlDR["Row_Id"]);
                    state.StateName = SqlDR["StateName"].ToString();
                    state.CountryId = Convert.ToInt32(SqlDR["CountryId"].ToString());
                    States.Add(state);
                }

                JavaScriptSerializer JS = new JavaScriptSerializer();
                Context.Response.Write(JS.Serialize(States));

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }
            }
        }

        [WebMethod]
        public void GetCity(int StateId)
        {
            List<City> Cities = new List<City>();
            using (SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString()))
            {
                SqlCommand SqlComm = new SqlCommand("stp_Emp_GetCityByStateId", SqlConn);
                SqlComm.CommandType = CommandType.StoredProcedure;

                SqlParameter param = new SqlParameter()
                {
                    ParameterName = "@StateId",
                    Value = StateId
                };

                SqlComm.Parameters.Add(param);

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlDataReader SqlDR = SqlComm.ExecuteReader();

                while (SqlDR.Read())
                {
                    City city = new City();
                    city.Row_Id = Convert.ToInt32(SqlDR["Row_Id"]);
                    city.CityName = SqlDR["CityName"].ToString();
                    city.StateId = Convert.ToInt32(SqlDR["StateId"]);
                    Cities.Add(city);
                }

                JavaScriptSerializer JS = new JavaScriptSerializer();
                Context.Response.Write(JS.Serialize(Cities));

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }
            }
        }
    }
}
