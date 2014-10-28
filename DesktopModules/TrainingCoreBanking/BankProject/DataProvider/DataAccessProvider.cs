using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Linq;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace BankProject.DataProvider
{
    public class DataAccessProvider
    {
        private string _connectionString;
        private DbContext _db;

        public DbContext DBContext
        {
            get { return _db; }

        }
        private static DataAccessProvider _dataAccessProvider;

        private DataAccessProvider()
        {
            _connectionString = WebConfigurationManager.ConnectionStrings["VietVictoryCoreBanking"].ConnectionString;
            _db = new DbContext(this._connectionString);
        }

        public static DataAccessProvider getInstance()
        {
            if (_dataAccessProvider == null) 
            {
                _dataAccessProvider = new DataAccessProvider();
            }
            return _dataAccessProvider;
        }





    }
}