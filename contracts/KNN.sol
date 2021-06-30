// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

/// @title 委托投票
contract KNN {
    
    address owner;
    
    int32[] public m_data;

    int32[] private m_TrainData;
    int32[] private m_TestData;
    int32[] private m_TrainLabels;
    int32[] private m_TestLabels;

    uint32 private m_k;
    uint32 private m_test_row;
    uint32 private m_train_row;
    uint32 private m_column;


    event DeploySuccess(address _from);
    event ReadDataSuccess(address _from);

    constructor() public {
        owner = msg.sender;
        m_data = new int32[](0);
        emit DeploySuccess(msg.sender);
    }

    function get_data_size() public view returns(uint256 len){
        len = m_data.length;
    }

    function add_data(int32[700] memory tmp_data) public {
        for(uint32 i = 0; i < tmp_data.length; ++i)
            m_data.push(tmp_data[i]);
    }


    function readData() internal {
        require(m_data.length >= (m_train_row + m_test_row)*(m_column+1), "data is not enough");
        m_TrainData = new int32[](m_train_row*m_column);
        m_TestData = new int32[](m_test_row*m_column);
        m_TrainLabels = new int32[](m_train_row);
        m_TestLabels = new int32[](m_test_row); 

        uint32 i = 0;
        uint32 test_data_idx = 0;
        uint32 test_label_idx = 0;
        // reading test data
        while(i < m_data.length)
        {
            for (uint32 j = 0; j < m_column; ++j)
                m_TestData[test_data_idx++] = m_data[i++];
            m_TestLabels[test_label_idx++] = m_data[i++];
            if( test_label_idx >= m_test_row)
                break;
        }

        uint32 train_data_idx = 0;
        uint32 train_label_idx = 0;
        // reading train data
        while(i < m_data.length)
        {
            for (uint32 j = 0; j < m_column; ++j)
                m_TrainData[train_data_idx++] = m_data[i++];
            m_TrainLabels[train_label_idx++] = m_data[i++];
            if( train_label_idx >= m_train_row)
                break;
        }

        emit ReadDataSuccess(msg.sender);
    }

    function CorrectRate(uint32 k, uint32 column, uint32 test_row, uint32 train_row) 
    public returns(uint32 CorrectNum){
        require(k < 20, "too many classes");
        m_k = k;
        m_column = column;
        m_test_row = test_row;
        m_train_row = train_row;
        readData();

        {
            CorrectNum = 0;
            for(uint32 i = 0; i < m_test_row; ++i){
                int32[] memory Input = new int32[](m_column);
                uint32 idx = 0;
                for(uint32 x = i * m_column; x < Input.length; ++x)
                    Input[idx++] = m_TestData[x];
                if(Classify(Input) == m_TestLabels[i])
                    CorrectNum++;
            }
        }
        return CorrectNum;
    }

    function Classify(int32[] memory Input) internal returns(int32 idx){
        int32[] memory Distance = new int32[](m_train_row);
        for(uint32 i = 0; i < m_train_row; ++i){
            Distance[i] = 0;
            // uint32 param = i * m_column;
            // Distance[i] = GetDistance(Input, m_TrainData, param);
        }
        int32[] memory LabelMinIdx = new int32[](m_k);
        for(uint32 i = 0; i < m_k; ++i){
            LabelMinIdx[i] = -1;
            LabelMinIdx[i] = GetMinDistIndex(Distance);
            Distance[uint32(LabelMinIdx[i])] = (9999);
        }
        idx = GetMaxSeq(LabelMinIdx);
        return idx;
    }

    function GetDistance(int32[] memory Input, int32[] memory TrainData, uint32 i) public returns (int32 Dist) {
        Dist = 0;
        for(uint32 k = 0; k < Input.length; ++k){
            int32 diff = (Input[k] - TrainData[i++]);
            diff = diff * diff;
            Dist += diff;
        }
    }


    function GetMinDistIndex(int32[] memory Distance) internal view returns(int32 Index){
        int32 DistMin = 9999;
        for(uint32 i = 0; i < Distance.length; ++i){
            if (Distance[i] < DistMin && Distance[i] >= 0){
                DistMin = Distance[i];
                Index = int32(i);
            }
        }
        require(Index >= int32(0));
    }


    function GetMaxSeq(int32[] memory LabelMinIdx) internal view returns (int32 LabelMaxSeq){
        uint32[] memory LabelAppearTime = new uint32[](m_k);
        uint32 times = 0;
        LabelMaxSeq = -1;
        for(uint32 i = 0; i < m_k; ++i){
            int32 label = m_TrainLabels[uint32(LabelMinIdx[i])];
            if(++LabelAppearTime[uint32(label)]> times){
                times = LabelAppearTime[uint32(label)];
                LabelMaxSeq = label;
            }
        }
        require(LabelMaxSeq>=0, "Error of GetMaxSeq");
    }
}